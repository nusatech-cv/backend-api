class CreateServices < ActiveRecord::Migration[7.0]
  def change
    create_table :services do |t|
      t.string "name"
      t.text "description"
      t.decimal "price_per_hour", precision: 10, scale: 2, null: false
      t.text "image"
      t.integer "minimum_duration"

      t.timestamps
    end
  end
end
