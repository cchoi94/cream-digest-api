class AddStartEquityToBalances < ActiveRecord::Migration[6.1]
  def change
    add_column :balances, :yesterday_start_equity, :decimal
  end
end
