class CreateAccessRights < ActiveRecord::Migration[5.2]
  def up
    create_table :access_rights do |t|
      t.string "name", :limit => 50, :null => false
      t.datetime "deleted_at"
      t.timestamps
    end
  end

  def down
    drop_table :access_rights
  end
end
