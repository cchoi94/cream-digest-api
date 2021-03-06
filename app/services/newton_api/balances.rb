module NewtonApi
  class Balances < NewtonApi::Sync
    def self.update(integration, sync_type)
      res = HTTParty.get("https://api.newton.co/v1/balances", headers: headers(integration))
      types_of_currency = ["CAD", "USD"]
      types_of_currency.each do |currency|
        existing_balance = integration.balances.find_by(currency: currency)
        if existing_balance.present?
          existing_balance.update(
            cash: if res["CAD"] >= 0.1
                    currency == "CAD" ? res["CAD"] : convert_currency(res["CAD"], "CAD", "USD")
                  else
                    0.0
                  end,
            market_value: get_total_equity_with_currency(res.except(:CAD), currency),
            total_equity: get_total_equity_with_currency(res, currency),
            yesterday_start_equity: sync_type == "morning" ? existing_balance.total_equity : existing_balance.yesterday_start_equity
          )
        else
          integration.balances.create(
            currency: currency,
            cash: if res["CAD"] >= 0.1
                    currency == "CAD" ? res["CAD"] : convert_currency(res["CAD"], "CAD", "USD")
                  else
                    0.0
                  end,
            market_value: get_total_equity_with_currency(res.except(:CAD), currency),
            total_equity: get_total_equity_with_currency(res, currency)
          )
        end
      end
    rescue => error
      Rails.logger.error(error.message)
      error
    end
  end
end
