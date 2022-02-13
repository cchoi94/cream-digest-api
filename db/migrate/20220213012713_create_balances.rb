class CreateBalances < ActiveRecord::Migration[6.1]
  def change
    create_table :balances do |t|
      t.string :currency
      t.decimal :total_equity
      t.decimal :cash
      t.decimal :market_value
      t.references :integration, null: false, foreign_key: true

      t.timestamps
    end
  end
end
