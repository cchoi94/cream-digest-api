class AddHostServerToIntegrations < ActiveRecord::Migration[6.1]
  def change
    add_column :integrations, :host_server, :string
  end
end
