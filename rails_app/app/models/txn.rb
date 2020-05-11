class Txn < ApplicationRecord
  include AASM

  belongs_to :txn_status
  belongs_to :txn_type
  belongs_to :user
  belongs_to :src_bank, class_name: 'Bank'
  belongs_to :dst_bank, class_name: 'Bank'

  after_create :process!

  aasm requires_lock: true do
    # Processing
    state :created, initial: true
    state :processing
    state :success
    state :rejected

    event :process do
      transitions from: :created, to: :processing
    end

    event :check do
      transitions from: :processing, to: :rejected, guard: :below_treshold?
      transitions from: :processing, to: :success
    end
  end

  private def below_treshold?
    amt.to_f < 100.0
  end
end