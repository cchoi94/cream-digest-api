require "money/bank/currencylayer_bank"

module CurrencylayerApi
  class ExchangeCurrency < ApplicationService
    def initialize(amount, currency_from, currency_to)
      @amount = amount
      @currency_from = currency_from
      @currency_to = currency_to
    end

    def call
      init_configs
      Money.new(amount, currency_from).exchange_to(currency_to).to_f
    end

    private

    def init_configs
      mclb = Money::Bank::CurrencylayerBank.new
      mclb.access_key = Rails.application.credentials.dig(:currencylayer, :api_key)
      mclb.update_rates
      mclb.cache = proc do |v|
        key = "money:currencylayer_bank"
        if v
          Rails.cache.write(key, v)
        else
          Rails.cache.fetch(key)
        end
      end
      Money.default_bank = mclb
    end
  end
end
