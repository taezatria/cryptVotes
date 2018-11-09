class CreateUsers < ActiveRecord::Migration[5.2]
  def up
    create_table :users do |t|
      t.string "name", :limit => 50, :null => false
      t.string "idNumber", :limit => 20, :unique => true, :null => false
      t.string "email", :limit => 50, :null => false
      t.string "username", :unique => true
      t.text "password"
      t.string "phone", :limit => 20, :null => false
      t.text "addressKey"
      t.text "publicKey"
      t.text "privateKey"
      t.boolean "approved", :default => false
      t.boolean "firstLogin", :default => true
      t.datetime "deleted_at"
      t.timestamps
    end
  end

  def down
    drop_table :users
  end
end
