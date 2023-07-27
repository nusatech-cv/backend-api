class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.integer "user_id"
      t.string "messages"
      t.boolean "is_send", default: false
      t.boolean "is_read", default: false
      t.integer "reference_id"
      t.string "reference_type"

      t.timestamps
    end
  end
end
