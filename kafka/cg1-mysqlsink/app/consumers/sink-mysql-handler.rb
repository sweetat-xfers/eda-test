require 'yaml'
require 'erb'
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
    db_config_file = File.read('config/database.yml')
    db_config_erb = ERB.new(db_config_file).result
    db_config = YAML::load(db_config_erb)
    puts db_config

    env = ENV.fetch('environment', 'development')
    curr_db_config = db_config[env]

    ActiveRecord::Base.establish_connection(curr_db_config)
  end 

  def consume(payload, _metadata)
    Phobos.logger.info "consume (#{payload}),(#{_metadata})"
    txn = Txn.new.from_json(payload)
    Phobos.logger.info "Txn.new.from_json(#{txn})"

    ActiveRecord::Base.transaction do
      unless txn.save
        txn.errors.messages.each do |field, messages|
          Phobos.logger.error "error(#{txn}).(#{field}: #{messages})"
        end
      end
    end
  end
end