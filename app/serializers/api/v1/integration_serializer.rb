module Api
  module V1
    class IntegrationSerializer < ActiveModel::Serializer
      attributes :id, :user_id
    end
  end
end
