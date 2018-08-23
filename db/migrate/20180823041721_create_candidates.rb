class CreateCandidates < ActiveRecord::Migration[5.2]
  def up
    create_table :candidates do |t|
      t.references :users
      t.references :elections
      t.text "description"
      t.text "image", :null => false
      t.timestamps
    end
  end
  
  def down
    drop_table :candidates
  end
end
