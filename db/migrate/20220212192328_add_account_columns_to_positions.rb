class AddAccountColumnsToPositions < ActiveRecord::Migration[6.1]
  def change
    add_column :positions, :account, :json, default: {
      type: "",
      id: "",
      status: ""
    }
  end
end
