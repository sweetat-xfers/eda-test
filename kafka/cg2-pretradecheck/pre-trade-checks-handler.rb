require "json"
require "phobos"

class PreTradeChecksHandler
    include Phobos::Handler
    include Phobos::Producer

    def consume(payload, _metadata)
        Phobos.logger.info("consume.(#{payload}).(#{_metadata})")
        # Parse JSON
        txn = JSON.parse(payload)
        Phobos.logger.info("txn.(#{txn["amt"].to_f})")
        if txn["amt"].to_f < 100.0
            producer.async_publish(
                topic: "txn.pretrade.ok", 
                payload: "#{payload}",
                )
            Phobos.logger.info("txn.pretrade.ok.(#{payload}).(#{_metadata})")
        else
            txn[:errors] = {'msg': 'too.low'}
            txn["txn_status_id"] = 7 # This should be a static constant that may just be configured at initial creation
            rej_payload = txn.to_json
            producer.async_publish(
                topic: "txn.pretrade.rejected", 
                payload: "#{rej_payload}",
                )
            Phobos.logger.info("txn.pretrade.rejected.(#{rej_payload}).(#{_metadata})")
        end
    end
  end