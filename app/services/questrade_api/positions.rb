module QuestradeApi
  class Positions < QuestradeApi::Sync
    def self.update(integration, account, sync_type)
      new_headers = headers(integration)
      res = HTTParty.get("#{integration.host_server}v1/accounts/#{account["number"]}/positions", headers: new_headers)
      res["positions"].each do |p|
        next unless p["openQuantity"] > 0
        existing_position = Stock.find_by(name: p["symbol"])
        if existing_position.present?
          existing_position.update(
            account: {
              type: account["type"],
              number: integration.encrypt_string(account["number"]),
              status: account["status"]
            },
            amount: p["openQuantity"],
            price: p["currentPrice"],
            open_pnl: p["openPnl"],
            yesterday_start_equity: sync_type == "morning" ? existing_position.amount * existing_position.price : existing_position.yesterday_start_equity
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
      stock_positions_to_be_deleted = Stock.where.not(name: res["positions"].pluck("symbol"))
      stock_positions_to_be_deleted.destroy_all
    rescue => error
      Rails.logger.error(error.message)
      error
    end
  end
end
