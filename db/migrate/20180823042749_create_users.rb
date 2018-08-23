class CreateUsers < ActiveRecord::Migration[5.2]
  def up
    create_table :users do |t|
      t.string "name", :limit => 50, :null => false
      t.string "idNumber", :limit => 20, :null => false
      t.string "email", :limit => 50, :null => false
      t.string "username", :limit => 20, :null => false
      t.text "password", :null => false
      t.string "phone", :limit => 20
      t.text "addressKey"
      t.text "publicKey"
      t.text "privateKey"
      t.text "signAddress"
      t.boolean "hasAttend", :default => false
      t.boolean "hasVote", :default => false
      t.timestamps
    end
  end

  def down
    drop_table :users
  end
end
