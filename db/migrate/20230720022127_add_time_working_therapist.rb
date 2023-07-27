class AddTimeWorkingTherapist < ActiveRecord::Migration[7.0]
  def change
    remove_column :therapists, :working_hour

    add_column :therapists, :day_start, :integer, default: 0,null: false
    add_column :therapists, :day_end, :integer, default: 0, null: false
    add_column :therapists, :working_start, :time
    add_column :therapists, :working_end, :time
  end
end
