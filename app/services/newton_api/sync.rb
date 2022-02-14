# Balances are CAD and USD
# Positions all USD

require "money"
require "cryptocompare"

module NewtonApi
  class Sync < ApplicationService
    attr_reader :integration

    def initialize(integration)
      @integration = integration
    end

    def call
      NewtonApi::Positions.update(integration)
      NewtonApi::Balances.update(integration)
    end

    def self.headers(integration)
      current_time = DateTime.now.strftime("%s")
      signature_data = [
        "GET",
        "",
        "/v1/balances",
        "",
        current_time
      ].join(":")
      key = integration.decrypt_string(integration.client_key)
      digest = OpenSSL::Digest.new("sha256")
      computed_signature = OpenSSL::HMAC.digest(digest, integration.decrypt_string(integration.client_secret), signature_data)
      {
        NewtonAPIAuth: "#{integration.decrypt_string(integration.client_key)}:#{Base64.encode64 computed_signature}",
        NewtonDate: current_time
      }
    rescue => error
      Rails.logger.error(error.message)
      error
    end

    def self.convert_currency(amount, currency_from, currency_to)
      CurrencylayerApi::ExchangeCurrency.call(amount, currency_from, currency_to)
    end

    def self.convert_crypto_to_currency(symbol)
      Cryptocompare::Price.find(symbol, "USD", {api_key: Rails.application.credentials.dig(:cryptocompare, :api_key)})[symbol]["USD"]
    end

    def self.get_total_equity_with_currency(balance, currency)
      total_equity = 0
      balance.each do |crypto_symbol, value|
        symbol = crypto_symbol
        comparision = Cryptocompare::Price.find(symbol, currency, {api_key: Rails.application.credentials.dig(:cryptocompare, :api_key)})
        total_equity += comparision[symbol][currency]
      end
      total_equity
    end
  end
end
