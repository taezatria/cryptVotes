class CreateCandidates < ActiveRecord::Migration[5.2]
  def up
    create_table :candidates do |t|
      t.references :user
      t.references :election
      t.text "description"
      t.text "image", :null => false
      t.datetime "deleted_at"
      t.timestamps
    end
  end
  
  def down
    drop_table :candidates
  end
end
