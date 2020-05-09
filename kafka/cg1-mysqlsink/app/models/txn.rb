class Txn < ApplicationRecord
  belongs_to :txn_status
  belongs_to :txn_type
  belongs_to :user
  belongs_to :src_bank, class_name: 'Bank'
  belongs_to :dst_bank, class_name: 'Bank'
end
