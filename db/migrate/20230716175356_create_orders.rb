class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'postgis'
    
    create_table :orders do |t|
      t.references "user", index: true, null: false, foreign_key: true
      t.references "therapist", index: true, null: false, foreign_key: true
      t.references "service", index: true, null: false, foreign_key: true
      t.string "order_status", default: "WAITING_CONFIRMATION", comment: "['WAITING_CONFIRMATION', 'WAITING_PAYMENT', 'PAID', 'DONE', 'CANCELED', 'EXPIRED']"
      t.datetime "appointment_date"
      t.integer "appointment_duration"
      t.decimal "total_price", precision: 10, scale: 2, null: false
      t.column "location", :geometry, geographic: true

      t.timestamps
    end
  end
end
