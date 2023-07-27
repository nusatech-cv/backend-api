class AddRegistrationTokenOnUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :token_device, :string, null: true
  end
end
