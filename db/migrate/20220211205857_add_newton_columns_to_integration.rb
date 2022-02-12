class AddNewtonColumnsToIntegration < ActiveRecord::Migration[6.1]
  def change
    add_column :integrations, :client_id, :string
    add_column :integrations, :secret_key, :string
  end
end
