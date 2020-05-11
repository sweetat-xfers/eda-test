require "json"
require "racecar"

class PreTradeChecksConsumer < Racecar::Consumer
    subscribes_to "txn.created", start_from_beginning: false

    def process(message)
        puts("process.(#{message})")
        # Parse JSON
        txn = JSON.parse(message.value)
        amt = txn.fetch("amt", "0.0").to_f
        puts("txn.(#{amt})")
        if amt < 100.0
            produce(
                "#{message}",
                topic: "txn.pretrade.ok", 
                key: message.key,
                )
            puts("txn.pretrade.ok.(#{message})")
        else
            txn[:errors] = {'msg': 'too.low'}
            txn["txn_status_id"] = 7 # This should be a static constant that may just be configured at initial creation
            rej_payload = txn.to_json
            produce(
                "#{rej_payload}",
                topic: "txn.pretrade.rejected", 
                key: message.key,
                )
            puts("txn.pretrade.rejected.(#{rej_payload})")
        end
    rescue Exception => e
        puts "Failed to process message in #{message.topic}/#{message.partition} at offset #{message.offset}: #{e}"
    end
  end