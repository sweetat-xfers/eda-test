class Transaction < ActiveRecord::Base
  include AASM

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
      transitions from: :processing, to: :rejected, guard: :pre_trade_check?
      transitions from: :processing, to: :success
    end
  end
end