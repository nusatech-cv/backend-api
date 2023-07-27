class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string "first_name_encrypted"
      t.string "last_name_encrypted"
      t.string "email"
      t.string "google_id"
      t.string "avatar"
      t.string "role", comment: 'user, therapist, admin'

      t.timestamps
    end
  end
end
