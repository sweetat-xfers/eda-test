require "spec_helper"
require_relative "../pre_trade_checks_consumer"

RSpec.describe PreTradeChecksConsumer do
  it "queues txn in txn.pretrades.ok queue when amt < 100.0" do
    message = double("message", 
            value: Hash[
              "id" => 1,
              "amt" => 99.0,
              ].to_json,
            key: 123, 
            )

    consumer = PreTradeChecksConsumer.new
    consumer.process(message)

    messages = kafka.messages_in("txn.pretrade.ok")
    expect(messages.map(&:payload)).to exists
  end

  it "queues txn in txn.pretrades.rejected queue when amt > 100.0" do
    message = double("message", 
            value: Hash[
              "id" => 1,
              "amt" => 101.0,
              ].to_json,
            key: 123, 
            )

    consumer = PreTradeChecksConsumer.new
    consumer.process(message)

    messages = kafka.messages_in("txn.pretrade.rejected")
    expect(messages.map(&:payload)).to exists
  end
end