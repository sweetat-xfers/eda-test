class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.decimal :amt, precision: 20, scale: 5
      t.string :aasm_state,  limit: 191
      t.references :type, null: false
      t.references :user, null: false, foreign_key: { to_table: :users }
      t.references :src_bank, null: false, foreign_key: { to_table: :banks } 
      t.references :dst_bank, null: false, foreign_key: { to_table: :banks } 

      t.timestamps
    end
  end
end
