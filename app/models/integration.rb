class Integration < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  belongs_to :user
  has_many :assets

  def encrypt_token(token)
    crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base[0..31],
      Rails.application.secrets.secret_key_base)
    crypt.encrypt_and_sign(token)
  end
end
