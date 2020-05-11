require "json"
require "phobos"

class XfersFeesHandler
    include Phobos::Handler
    include Phobos::Producer

    @@fee_percent 

    def self.start(kafka_client)
        fee_percent_str = ENV["FEE_PERCENT"] ||= "5.0"
        @@fee_percent = fee_percent_str.to_f
        Phobos.logger.info("fee_percent.(#{@@fee_percent})")
    rescue
        raise StandardError.new "self.start(#{fee_percent_str}).invalid"
    end

    def consume(payload, _metadata)
        Phobos.logger.info("consume.(#{payload}).(#{_metadata})")
        # Parse JSON
        txn = JSON.parse(payload)
        Phobos.logger.info("txn.(#{txn["amt"].to_f})")
        amt = txn["amt"].to_f

        xfers_fees = amt * @@fee_percent

        payload_hash = Hash[
            "id" => txn["id"],
            "amt" => amt,
            "xfers_fee" => xfers_fees,
        ]
        payload = payload_hash.to_json

        producer.async_publish(
            topic: "txn.xfers_fees", 
            payload: "#{payload}",
            )
        Phobos.logger.info("txn.xfers_fees.(#{payload})")
    end
  end