module QuestradeApi
  class Accounts < QuestradeApi::Sync
    BASE_URL = "https://api01.iq.questrade.com/v1/accounts"

    def self.get(integration)
      puts "@@@@@@@@@@@ accounts integration object @@@@@@@@@"
      puts integration
      res = HTTParty.get(BASE_URL, headers: headers(integration))
      puts "@@@@@@@@@@@ after get request for accounts @@@@@@@@@@"
      puts res.parsed_response["accounts"]
      puts res
      res.parsed_response["accounts"]
    rescue => error
      Rails.logger.error(error.message)
      error
    end
  end
end
