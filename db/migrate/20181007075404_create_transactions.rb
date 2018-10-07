class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.references :users
      t.references :elections
      t.text "txid", :null => false
      t.text "digSign", :null => false
      t.datetime "deleted_at"
      t.timestamps
    end
  end
end
