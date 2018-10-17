class CreateOrganizers < ActiveRecord::Migration[5.2]
  def up
    create_table :organizers do |t|
      t.references :user
      t.references :election
      t.references :access_right
      t.datetime "deleted_at"
      t.timestamps
    end
  end

  def down 
    drop_table :organizers
  end
end
