require "json"
require "racecar"

class XfersFeesConsumer < Racecar::Consumer
    subscribes_to "txn.created", start_from_beginning: false

    @@fee_percent 

    def self.start(kafka_client)
        fee_percent_str = ENV["FEE_PERCENT"] ||= "5.0"
        @@fee_percent = fee_percent_str.to_f
        Phobos.logger.info("fee_percent.(#{@@fee_percent})")
    rescue
        raise StandardError.new "self.start(#{fee_percent_str}).invalid"
    end

    def process(message)
        puts("process.(#{message})")
        # Parse JSON
        txn = JSON.parse(message.value)
        amt = txn.fetch("amt", "0.0").to_f
        puts("amt.(#{amt})")

        xfers_fees = amt * @@fee_percent

        payload = Hash[
            "id" => txn["id"],
            "amt" => amt,
            "xfers_fee" => xfers_fees,
        ].to_json

        produce(
            topic: "txn.xfers_fees", 
            payload: "#{payload}",
            key: message.key,
            )
        puts("txn.xfers_fees.(#{payload})")
    rescue Exception => e
        puts "Failed to process message in #{message.topic}/#{message.partition} at offset #{message.offset}: #{e}"
    end
  end