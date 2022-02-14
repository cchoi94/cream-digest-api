module QuestradeApi
  class Balances < QuestradeApi::Sync
    def self.update(integration, account)
      new_headers = headers(integration)
      puts "@@@@@@@@"
      puts new_headers
      res = HTTParty.get("#{integration.host_server}v1/accounts/#{account["number"]}/balances", headers: new_headers)
      if integration.balances.present?
        integration.balances.destroy_all
      end
      res["combinedBalances"].each do |b|
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
