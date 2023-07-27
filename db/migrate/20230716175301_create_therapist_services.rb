class CreateTherapistServices < ActiveRecord::Migration[7.0]
  def change
    create_table :therapist_services do |t|
      t.references "therapist", index: true, null: false, foreign_key: true
      t.references "service", index: true, null: false, foreign_key: true

      t.timestamps
    end
  end
end
