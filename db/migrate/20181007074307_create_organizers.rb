class CreateOrganizers < ActiveRecord::Migration[5.2]
  def change
    create_table :organizers do |t|
      t.references :users
      t.references :elections
      t.references :access_rights
      t.datetime "deleted_at"
      t.timestamps
    end
  end
end
