class CreateAddressLists < ActiveRecord::Migration[5.2]
  def change
    create_table :address_lists do |t|
      t.text "address", :null => false
      t.datetime "deleted_at"
      t.timestamps
    end
  end
end
