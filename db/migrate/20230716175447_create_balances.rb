class CreateBalances < ActiveRecord::Migration[7.0]
  def change
    create_table :balances do |t|
      t.references "therapist", index: true, null: false, foreign_key: true
      t.decimal "balance_amount", precision: 10, scale: 2, default: 0

      t.timestamps
    end
  end
end
