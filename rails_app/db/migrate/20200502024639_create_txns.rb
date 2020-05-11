class CreateTxns < ActiveRecord::Migration[6.0]
  def change
    create_table :txns do |t|
      t.decimal :amt, precision: 20, scale: 5
      t.references :txn_status, null: false, foreign_key: { to_table: :txn_statuses }
      t.references :txn_type, null: false, foreign_key: { to_table: :txn_types }
      t.references :user, null: false, foreign_key: { to_table: :users }
      t.references :src_bank, null: false, foreign_key: { to_table: :banks } 
      t.references :dst_bank, null: false, foreign_key: { to_table: :banks } 
      t.string   "aasm_state",                          limit: 191

      t.timestamps
    end
  end
end
