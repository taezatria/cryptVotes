class CreateAddressLists < ActiveRecord::Migration[5.2]
  def up
    create_table :address_lists do |t|
      t.text "address", :null => false
      t.text "tx"
      t.boolean "counted", :default => false
      t.datetime "deleted_at"
      t.timestamps
    end
  end

  def down
    drop_table :address_lists
  end
end
