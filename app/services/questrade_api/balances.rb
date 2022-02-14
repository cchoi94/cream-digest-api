module QuestradeApi
  class Balances < QuestradeApi::Sync
    def self.update(integration, account)
      new_headers = headers(integration)
      res = HTTParty.get("#{integration.host_server}v1/accounts/#{account["number"]}/balances", headers: new_headers)
      res["combinedBalances"].each do |b|
        existing_balance = integration.balances.find_by(currency: b["currency"])
        if existing_balance.present?
          existing_balance.update(
            total_equity: b["totalEquity"],
            cash: b["cash"],
            market_value: b["marketValue"]
          )
        else
          integration.balances.create(
            currency: b["currency"],
            total_equity: b["totalEquity"],
            cash: b["cash"],
            market_value: b["marketValue"]
          )
        end
      end
    rescue => error
      Rails.logger.error(error.message)
      error
    end
  end
end
