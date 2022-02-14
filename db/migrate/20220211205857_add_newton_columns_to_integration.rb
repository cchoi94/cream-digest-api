class AddNewtonColumnsToIntegration < ActiveRecord::Migration[6.1]
  def change
    add_column :integrations, :client_key, :string
    add_column :integrations, :client_secret, :string
  end
end
