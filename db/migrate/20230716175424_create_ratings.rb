class CreateRatings < ActiveRecord::Migration[7.0]
  def change
    create_table :ratings do |t|
      t.references "user", index: true, null: false, foreign_key: true
      t.references "therapist", index: true, null: false, foreign_key: true
      t.references "order", index: true, null: false, foreign_key: true
      t.integer "rating", limit: 5
      t.text "note"

      t.timestamps
    end
  end
end
