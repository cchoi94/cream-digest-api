class Integration < ApplicationRecord
  belongs_to :user
  has_many :positions

  def encrypt_string(string)
    crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base[0..31],
      Rails.application.secrets.secret_key_base)
    crypt.encrypt_and_sign(string)
  end

  def handle_positions_creation
    case name
    when 'questrade'
      QuestradeApi::Base.call
    else
      nil
    end
    # create_position
  end
end
