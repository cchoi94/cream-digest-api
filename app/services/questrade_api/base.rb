module QuestradeApi
  class Base < ApplicationService

    def initialize(integration)
      @integration = integration
    end

    def call
      questrade_accounts = QuestradeApi::GetAccounts.data
      return [] unless questrade_accounts.present?
      questrade_accounts.each |qa| do
        puts qa
      end
      #   if qa[:status] ==
      #   qa[:number]
      #   qa[:type]
      #   qa[:status]
      # end
    end

    def self.headers

      {
        "Content-Type": "application/json",
        Authorization: "Bearer #{integration.access_token}"
      }
    end

  end
end