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
      puts "@@@@@@@@@@ headers top @@@@@@@@@@@"
      res = HTTParty.get("https://login.questrade.com/oauth2/token?grant_type=refresh_token&refresh_token=#{integration.decrypt_string(integration.refresh_token)}")
      puts res
      puts "@@@@@@@@@@ headers after get call @@@@@@@@@@@"
      integration.update(
        access_token: integration.encrypt_string(res.parsed_response["access_token"]),
        refresh_token: integration.encrypt_string(res.parsed_response["refresh_token"])
      )
      {
        "Content-Type": "application/json",
        Accept: "application/json",
        Authorization: "Bearer #{res.parsed_response["access_token"]}"
      }
    end
  end
end
