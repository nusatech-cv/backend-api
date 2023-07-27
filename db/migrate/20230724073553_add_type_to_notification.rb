class AddTypeToNotification < ActiveRecord::Migration[7.0]
  def change
    add_column :notifications, :tipe, :string, null: true
  end
end
