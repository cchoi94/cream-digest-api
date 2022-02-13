module QuestradeApi
  class Balances < QuestradeApi::Sync
    def self.update(integration, account)
      res = HTTParty.get("https://api01.iq.questrade.com/v1/accounts/#{account["number"]}/balances", headers: headers(integration))
      integration.balances.destroy_all
      res["perCurrencyBalances"].each do |b|
        integration.balances.create(
          currency: b["currency"],
          total_equity: b["totalEquity"],
          cash: b["cash"],
          market_value: b["marketValue"]
        )
      end
    rescue => error
      Rails.logger.error(error.message)
      error
    end
  end
end
