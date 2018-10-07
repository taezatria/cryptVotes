class CreateVoteResults < ActiveRecord::Migration[5.2]
  def change
    create_table :vote_results do |t|
      t.text "hex"
      t.text "blockHash"
      t.text "txid"
      t.text "fromAddress"
      t.text "toAddress"
      t.integer "amount"
      t.integer "confirmation"
      t.datetime "deleted_at"
      t.timestamps
    end
  end
end
