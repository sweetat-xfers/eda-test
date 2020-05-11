# Owner: Transactions Platform Team

class EventFiringJob
    include Sidekiq::Worker

    def perform(id, event)
        txn = Txn.find(id)
        aasm = txn.aasm

        aasm.fire!(event)
    end
end
  