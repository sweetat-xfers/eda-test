class CreateTxnStatuses < ActiveRecord::Migration[6.0]
  def change
    create_table :txn_statuses do |t|
      t.string :name

      t.timestamps
    end
  end
end
