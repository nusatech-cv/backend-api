class CreateActivityHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :activity_histories do |t|
      t.references "user", index: true, null: false, foreign_key: true
      t.string "activity_type"
      t.column "location", :geometry, geographic: true
      t.string "ip_address"
      t.string "device_info"
      t.string "result"

      t.timestamps
    end
  end
end
