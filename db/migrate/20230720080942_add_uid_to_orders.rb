class AddUidToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :uid, :string, null: false, after: :id
    add_column :orders, :note, :text, after: :total_price
  end
end
