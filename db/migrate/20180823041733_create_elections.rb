class CreateElections < ActiveRecord::Migration[5.2]
  def up
    create_table :elections do |t|
      t.string "name", :limit => 50, :null => false
      t.text "description"
      t.datetime "start_date", :null => false
      t.datetime "end_date", :null => false
      t.integer "participants", :null => false, :default => 0
      t.integer "status", :default => 0
      t.text "image", :null => false
      t.integer "cand", :default => 1
      t.text "addressKey"
      t.datetime "deleted_at"
      t.timestamps
    end
  end

  def down
    drop_table :elections
  end
end
