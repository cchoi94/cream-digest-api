# frozen_string_literal: true

class AddColumnsToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :phone, :string, default: ""
    add_column :users, :send_daily_email, :boolean, default: false
    add_column :users, :onboarding, :jsonb, default: {
      has_integration: false,
      has_choosen_option: false
    }
  end
end
