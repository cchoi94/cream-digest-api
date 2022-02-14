module QuestradeApi
  class Positions < QuestradeApi::Sync
    def self.update(integration, account)
      new_headers = headers(integration)
      res = HTTParty.get("#{integration.host_server}v1/accounts/#{account["number"]}/positions", headers: new_headers)
      res["positions"].each do |p|
        next unless p["openQuantity"] > 0
        exisiting_position = Stock.find_by(name: p["symbol"])
        if exisiting_position.present?
          exisiting_position.update(
            account: {
              type: account["type"],
              number: integration.encrypt_string(account["number"]),
              status: account["status"]
            },
            amount: p["openQuantity"],
            price: p["currentPrice"],
            open_pnl: p["openPnl"]
          )
        else
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
      end
      stock_positions_to_be_deleted = Stock.where.not(name: res["positions"].pluck('symbol'))
      stock_positions_to_be_deleted.destroy_all
    rescue => error
      Rails.logger.error(error.message)
      error
    end
  end
end
