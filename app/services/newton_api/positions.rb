module NewtonApi
  class Positions < NewtonApi::Sync
    def self.update(integration)
      res = HTTParty.get("https://api.newton.co/v1/balances", headers: headers(integration))
      integration.positions.destroy_all
      res.each do |symbol, value|
        next unless value != 0.0
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
    rescue => error
      Rails.logger.error(error.message)
      error
    end
  end
end
