class Integration < ApplicationRecord
  belongs_to :user
  has_many :positions, dependent: :destroy
  has_many :balances, dependent: :destroy

  def encrypt_string(string)
    crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secret_key_base[0..31],
      Rails.application.secret_key_base)
    crypt.encrypt_and_sign(string)
  end

  def decrypt_string(string)
    crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secret_key_base[0..31],
      Rails.application.secret_key_base)
    crypt.decrypt_and_verify(string)
  end

  def handle_positions_creation(args = {})
    case name
    when "questrade"
      QuestradeApi::Sync.call(integration: self, sync_type: args[:sync_type])
    when "newton"
      NewtonApi::Sync.call(integration: self, sync_type: args[:sync_type])
    end
  end
end
