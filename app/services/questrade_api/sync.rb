module QuestradeApi
  class Sync < ApplicationService
    attr_reader :integration

    def initialize(integration)
      @integration = integration
    end

    def call
      questrade_accounts = QuestradeApi::Accounts.get(integration)
      puts "@@@@@@@@@ questrade_accounts @@@@@@@@@"
      puts questrade_accounts
      return [] unless questrade_accounts.present?
      questrade_accounts.each do |qa|
        QuestradeApi::Positions.update(integration, qa)
        QuestradeApi::Balances.update(integration, qa)
      end
    end

    def self.headers(integration)
      res = HTTParty.get("https://login.questrade.com/oauth2/token?grant_type=refresh_token&refresh_token=#{integration.decrypt_string(integration.refresh_token)}")
      integration.update(
        access_token: integration.encrypt_string(res.parsed_response["access_token"]),
        refresh_token: integration.encrypt_string(res.parsed_response["refresh_token"])
      )
      {
        "Content-Type": "application/json",
        Accept: "application/json",
        Authorization: "Bearer #{res.parsed_response["access_token"]}"
      }
    rescue => error
      puts "@@@@@@@@@@ error headers @@@@@@@@@"
      puts error.message
      puts error
      Rails.logger.error(error.message)
      error
    end
  end
end
