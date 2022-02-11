# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :send_daily_email, :phone, :onboarding
end
