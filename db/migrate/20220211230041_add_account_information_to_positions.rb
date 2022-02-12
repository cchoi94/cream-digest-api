class AddAccountInformationToPositions < ActiveRecord::Migration[6.1]
  def change
    add_column :positions, :account_type, :string
    add_column :positions, :account_number, :string
  end
end
