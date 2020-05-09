require 'active_record'

require_relative '../models/application_record'
require_relative '../models/bank'
require_relative '../models/txn_status'
require_relative '../models/txn_type'
require_relative '../models/user'
require_relative '../models/txn'

class SinkMysqlHandler
  include Phobos::Handler

  def self.start(kafka_client)
    db_adapter = ENV["DATABASE_ADAPTER"] ||= "mysql2"
    db_url = ENV["DATABASE_URL"] ||= "mysql2://xfers:password@mysql:3306/edatest"
    Phobos.logger.info("db_adapter.(#{db_adapter}).db_url.(#{db_url})")

    ActiveRecord::Base.establish_connection(adapter: db_adapter, url: db_url)
    Phobos.logger.info("self.start.establish_connection(#{db_url})")
  end

  def consume(payload, _metadata)
    Phobos.logger.info "consume(#{payload}),(#{_metadata})"
    txn = Txn.new.from_json(payload)
    Phobos.logger.info "Txn.new.from_json(#{txn})"

    ActiveRecord::Base.transaction do
      unless txn.save
        txn.errors.messages.each do |field, messages|
          Phobos.logger.error "save.errors(#{txn}).(#{field}: #{messages})"
        end
      end
    end
  end
end