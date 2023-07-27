class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.references "order", index: true, null: false, foreign_key: true
      t.references "user", index: true, null: false, foreign_key: true
      t.string "payment_method", comment: "['OVO, 'DANA','RUPIAH_DIGITAL']"
      t.string "payment_status", default: "PENDING", comment: "['PENDING', 'SUCCESS', 'EXPIRED']"
      t.decimal "amount_paid", precision: 10, scale: 2, null: false
      t.string "to_account"
      t.string "sender_account"
      t.datetime "payment_expired"
      t.datetime "payment_at"

      t.timestamps
    end
  end
end
