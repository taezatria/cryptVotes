class CreateElections < ActiveRecord::Migration[5.2]
  def up
    create_table :elections do |t|
      t.string "name", :limit => 50, :null => false
      t.text "description"
      t.datetime "start_date", :null => false
      t.datetime "end_date", :null => false
      t.integer "number_voter", :null => false
      t.string "image", :limit => 100, :null => false
      t.timestamps
    end
  end

  def down
    drop_table :elections
  end
end