class CreateCandidates < ActiveRecord::Migration[5.2]
  def up
    create_table :candidates do |t|
      t.text "description"
      t.references :users, :foreign_key => true
      t.references :elections, :foreign_key => true
      t.string "image", :limit => 100, :null => false
      t.timestamps
    end
  end

  def down
    drop_table :candidates
  end
end
