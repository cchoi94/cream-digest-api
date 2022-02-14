module QuestradeApi
  class Positions < QuestradeApi::Sync
    def self.update(integration, account)
      res = HTTParty.get("#{integration.host_server}v1/accounts/#{account["number"]}/positions", headers: headers(integration))
      if integration.positions.present?
        integration.positions.destroy_all
      end
      res["positions"].each do |p|
        next unless p["openQuantity"] > 0
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
