class CreateVoters < ActiveRecord::Migration[5.2]
  def up
    create_table :voters do |t|
      t.references :users
      t.references :elections
      t.timestamps
    end
  end

  def down
    drop_table :voters
  end
end
