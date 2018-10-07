class CreateVoters < ActiveRecord::Migration[5.2]
  def up
    create_table :voters do |t|
      t.references :users
      t.references :elections
      t.boolean "firstLogin", :default => false
      t.boolean "hasAttend", :default => false
      t.boolean "hasVote", :default => false
      t.datetime "deleted_at"
      t.timestamps
    end
  end

  def down
    drop_table :voters
  end
end
