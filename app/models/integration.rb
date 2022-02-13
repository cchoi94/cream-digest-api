class Integration < ApplicationRecord
  belongs_to :user
  has_many :positions
  has_many :balances

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

  def handle_positions_creation
    case name
    when "questrade"
      QuestradeApi::Sync.call(self)
    end
  end
end
