class AddAppointmentStartEndToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :appointment_start_at, :datetime, null: true
    add_column :orders, :appointment_end, :datetime, null: true
  end
end
