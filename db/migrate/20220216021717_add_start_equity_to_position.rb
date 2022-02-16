class AddStartEquityToPosition < ActiveRecord::Migration[6.1]
  def change
    add_column :positions, :yesterday_start_equity, :decimal
  end
end
