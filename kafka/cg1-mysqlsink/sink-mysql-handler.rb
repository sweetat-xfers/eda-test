require 'active_record'
require 'phobos'

require_relative 'app/models/application_record'
require_relative 'app/models/bank'
require_relative 'app/models/txn_status'
require_relative 'app/models/txn_type'
require_relative 'app/models/user'
require_relative 'app/models/txn'

class SinkMysqlHandler
  include Phobos::Handler

  def self.start(kafka_client)
    db_url = ENV["DATABASE_URL"] ||= "mysql2://xfers:password@mysql:3306/edatest"
    Phobos.logger.info("db_adapter.(#{db_adapter}).db_url.(#{db_url})")

    ActiveRecord::Base.establish_connection(db_url)
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