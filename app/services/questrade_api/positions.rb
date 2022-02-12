module QuestradeApi
  class Positions < QuestradeApi::Sync
    def self.update(integration, account)
      res = HTTParty.get("https://api01.iq.questrade.com/v1/accounts/#{account["number"]}/positions", headers: headers(integration))
      integration.positions.destroy_all
      res["positions"].each do |p|
        integration.positions << Stock.new(
          account: {
            type: account["type"],
            number: integration.encrypt_string(account["number"]),
            status: account["status"]
          },
          name: p["symbol"],
          amount: p["openQuantity"],
          price: p["currentPrice"],
          open_pnl: p["openPnl"]
        )
      end
    rescue => error
      Rails.logger.error(error.message)
      error
    end
  end
end
