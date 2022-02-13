module QuestradeApi
  class Sync < ApplicationService
    attr_reader :integration

    def initialize(integration)
      @integration = integration
    end

    def call
      questrade_accounts = QuestradeApi::Accounts.get(integration)
      return [] unless questrade_accounts.present?
      questrade_accounts.each do |qa|
        QuestradeApi::Positions.update(integration, qa)
        QuestradeApi::Balances.update(integration, qa)
      end
    end

    def self.headers(integration)
      res = HTTParty.get("#{ENV["QUESTRADE_REFRESH_TOKEN_URL"]}#{integration.decrypt_string(integration.refresh_token)}", format: :json)
      integration.update(
        access_token: integration.encrypt_string(res["access_token"]),
        refresh_token: integration.encrypt_string(res["refresh_token"])
      )
      {
        "Content-Type": "application/json",
        Accept: "application/json",
        Authorization: "Bearer #{res["access_token"]}"
      }
    end
  end
end
