class CreateVoters < ActiveRecord::Migration[5.2]
  def up
    create_table :voters do |t|
      t.references :users, :foreign_key => true
      t.references :elections, :foreign_key => true
      t.timestamps
    end
  end

  def down
    drop_table :voters
  end
end
