class CreateTxnTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :txn_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
