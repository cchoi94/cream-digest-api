module QuestradeApi
  class Sync < ApplicationService
    attr_reader :integration, :sync_type

    def initialize(args)
      @integration = args[:integration]
      @sync_type = args[:sync_type]
    end

    def call
      questrade_accounts = QuestradeApi::Accounts.get(integration)
      return [] unless questrade_accounts.present?
      questrade_accounts.each do |qa|
        QuestradeApi::Positions.update(integration, qa, sync_type)
        QuestradeApi::Balances.update(integration, qa, sync_type)
      end
    end

    def self.headers(integration)
      res = HTTParty.get("https://login.questrade.com/oauth2/token?grant_type=refresh_token&refresh_token=#{integration.decrypt_string(integration.refresh_token)}")
      if res.success?
        puts "@@@ Success"
        puts res["access_token"]
        puts res["refresh_token"]
        puts res["api_server"]
        integration.update(
          access_token: integration.encrypt_string(res["access_token"]),
          refresh_token: integration.encrypt_string(res["refresh_token"]),
          host_server: res["api_server"]
        )
        {
          "Content-Type": "application/json",
          Host: res["api_server"],
          Authorization: "Bearer #{res["access_token"]}"
        }
      end
    rescue => error
      Rails.logger.error(error.message)
      error
    end
  end
end
