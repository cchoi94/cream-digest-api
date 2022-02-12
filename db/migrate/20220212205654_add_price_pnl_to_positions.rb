class AddPricePnlToPositions < ActiveRecord::Migration[6.1]
  def change
    add_column :positions, :price, :decimal
    add_column :positions, :open_pnl, :decimal
  end
end
