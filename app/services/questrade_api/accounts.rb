module QuestradeApi
  class Accounts < QuestradeApi::Sync
    BASE_URL = "https://api01.iq.questrade.com/v1/accounts"

    def self.get(integration)
      res = HTTParty.get(BASE_URL, headers: headers(integration))
      res["accounts"]
    rescue => error
      Rails.logger.error(error.message)
      error
    end
  end
end
