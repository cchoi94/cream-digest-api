class CreatePositions < ActiveRecord::Migration[6.1]
  def change
    create_table :positions do |t|
      t.string :name, null: false
      t.string :type, null: false
      t.decimal :amount, null: false
      t.decimal :start_of_day_price
      t.references :integration, null: false, foreign_key: true
      t.timestamps
    end
  end
end
