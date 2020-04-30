class CreateTxns < ActiveRecord::Migration[6.0]
  def change
    create_table :txns do |t|
      t.decimal :amt
      t.bigint :txn_status_id
      t.bigint :txn_type_id
      t.bigint :user_id
      t.bigint :src_bank
      t.bigint :dst_bank

      t.timestamps
    end
    add_foreign_key :txns, :txn_statuses
    add_foreign_key :txns, :txn_types
    add_foreign_key :txns, :users
    add_foreign_key :txns, :banks, column: :src_bank
    add_foreign_key :txns, :banks, column: :dst_bank
  end
end
