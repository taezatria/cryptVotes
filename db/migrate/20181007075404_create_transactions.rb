class CreateTransactions < ActiveRecord::Migration[5.2]
  def up
    create_table :transactions do |t|
      t.references :user
      t.references :election
      t.text "txid", :null => false
      t.text "digSign", :null => false
      t.datetime "deleted_at"
      t.timestamps
    end
  end

  def down
    drop_table :transactions
  end
end
