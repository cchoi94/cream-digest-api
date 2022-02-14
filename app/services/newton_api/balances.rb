module NewtonApi
  class Balances < NewtonApi::Sync
    def self.update(integration)
      res = HTTParty.get("https://api.newton.co/v1/balances", headers: headers(integration))
      integration.balances.destroy_all
      types_of_currency = ["CAD", "USD"]
      types_of_currency.each do |currency|
        integration.balances.create(
          currency: currency,
          cash: res["CAD"] >= 0.1 ? currency == "CAD" ? res["CAD"] : convert_currency(res["CAD"], "CAD", "USD") : 0.0,
          market_value: get_total_equity_with_currency(res.except(:CAD), currency),
          total_equity: get_total_equity_with_currency(res, currency)
        )
      end
    rescue => error
      Rails.logger.error(error.message)
      error
    end
  end
end
