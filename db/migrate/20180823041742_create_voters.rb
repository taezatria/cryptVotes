class CreateVoters < ActiveRecord::Migration[5.2]
  def up
    create_table :voters do |t|
      t.references :user
      t.references :election
      t.boolean "hasAttend", :default => false
      t.boolean "hasVote", :default => false
      t.timestamps
    end
  end

  def down
    drop_table :voters
  end
end
