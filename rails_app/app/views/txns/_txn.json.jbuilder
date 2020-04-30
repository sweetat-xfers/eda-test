json.extract! txn, :id, :txn_status_id, :txn_type_id, :user_id, :src_bank_id, :dst_bank_id, :amt, :created_at, :updated_at
json.url txn_url(txn, format: :json)
