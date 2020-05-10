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
  include Phobos::Producer

  def self.start(kafka_client)
    db_url = ENV["DATABASE_URL"] ||= "mysql2://xfers:password@mysql:3306/edatest"
    Phobos.logger.info("db_url.(#{db_url})")

    ActiveRecord::Base.establish_connection(db_url)
    Phobos.logger.info("self.start.establish_connection(#{db_url})")
  end

  def consume(payload, _metadata)
    Phobos.logger.info "consume(#{payload}),(#{_metadata})"
    txn = Txn.new.from_json(payload)
    Phobos.logger.info "txn.new.from_json(#{txn.to_json})"

    ActiveRecord::Base.transaction do
      if !txn.id and txn.save
        # We want the producer here for txn.created because
        # we need a txn.id to associate processors downstream
        txn_msg = txn.to_json
        Phobos.logger.info "Txn.save(#{txn_msg})"
        begin
          producer.async_publish(
              topic: "txn.created", 
              payload: "#{txn_msg}",
              )
          Phobos.logger.info "txn.created(#{txn_msg})"
        rescue 
          raise ActiveRecord::Rollback, "txn.created.failed(#{txn_msg})"
        end
      else
        # If it cannot save, we probably want to retry again.
        txn.errors.messages.each do |field, messages|
          Phobos.logger.error "save.errors(#{txn}).(#{field}: #{messages})"
        end
        # If we throw an exception, the handler will try again
        raise ActiveRecord::Rollback, "txn.save.failed(#{txn.errors})"
      end
    end
  end
end