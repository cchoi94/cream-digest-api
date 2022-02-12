class AddQuestradeAccountNumberToIntegrations < ActiveRecord::Migration[6.1]
  def change
    add_column :integrations, :questrade_account_number, :string
  end
end
