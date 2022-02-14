module NewtonApi
  class Positions < NewtonApi::Sync
    def self.update(integration)
      res = HTTParty.get("https://api.newton.co/v1/balances", headers: headers(integration))
      res.each do |symbol, value|
        next unless value != 0.0
        existing_position = Cryptocurrency.find_by(name: symbol)
        if existing_position.present?
          existing_position.update(
            account: {
              type: "",
              number: "",
              status: "Active"
            },
            amount: value,
            price: convert_crypto_to_currency(symbol)
          )
        else
          integration.positions << Cryptocurrency.new(
            account: {
              type: "",
              number: "",
              status: "Active"
            },
            name: symbol,
            amount: value,
            price: convert_crypto_to_currency(symbol)
          )
        end
        crypto_positions_to_be_deleted = Cryptocurrency.where.not(name: res.keys)
        crypto_positions_to_be_deleted.destroy_all
      end
    rescue => error
      Rails.logger.error(error.message)
      error
    end
  end
end
