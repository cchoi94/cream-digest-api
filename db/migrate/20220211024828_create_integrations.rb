# frozen_string_literal: true

class CreateIntegrations < ActiveRecord::Migration[6.1]
  def change
    create_table :integrations do |t|
      t.string :access_token
      t.string :refresh_token
      t.string :name, null: false
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
