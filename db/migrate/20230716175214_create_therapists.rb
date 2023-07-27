class CreateTherapists < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'postgis'
    
    create_table :therapists do |t|
      t.references "user", index: true, null: false, foreign_key: true
      t.column "location", :geometry, geographic: true
      t.integer "experience_years"
      t.text "photo"
      t.integer "working_hour"
      t.date "birthdate"
      t.string "gender", comment: 'MALE, FEMALE, OTHER'
      t.boolean "is_available", default: false

      t.timestamps
    end
  end
end
