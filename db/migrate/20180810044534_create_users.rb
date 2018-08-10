class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.name, :string, :limit => 50, :null => false
      t.idNumber, :string, :limit => 20, :null => false
      t.email, :string, :limit => 50, :null => false
      t.username, :string, :limit => 20, :null => false
      t.password, :text, :null => false
      t.phone, :string, :limit => 20
      t.addressKey, :text
      t.publicKey, :text
      t.privateKey, :text
      t.signAddress, :text
      t.hasAttend, :boolean, :default => false
      t.hasVote, :boolean, :default => false
      t.timestamps
    end
  end
end
