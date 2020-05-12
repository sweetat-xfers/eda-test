require 'active_record'
require 'phobos'

require_relative 'app/models/application_record'
require_relative 'app/models/bank'
require_relative 'app/models/txn_status'
require_relative 'app/models/txn_type'
require_relative 'app/models/user'
require_relative 'app/models/txn'

class TxnStatusSink < Racecar::Consumer
    subscribes_to "txn.created", start_from_beginning: false

    def initialize
        db_url = ENV["DATABASE_URL"] ||= "mysql2://xfers:password@mysql:3306/edatest"
        puts("db_url.(#{db_url})")

        ActiveRecord::Base.establish_connection(db_url)
        puts("self.start.establish_connection(#{db_url})")
    end

    def process(message)
        puts("process(#{message})")
        in_txn = JSON.parse(message.value)
        puts("process.txn(#{in_txn})")

        id = in_txn.fetch("id").to_i
        txn_status_id = in_txn.fetch("txn_status_id").to_i

        txn = Txn.find(id)
        if txn

            ActiveRecord::Base.transaction do
                unless txn.update_attribute( :txn_status_id, txn_status_id )
                    raise ActiveRecord::Rollback, "txn.created.failed(#{txn.errors.full_messages})"
                end
            end
        end
    end
end