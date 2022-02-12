module QuestradeApi
  class GetAccounts < QuestradeApi::Base
    BASE_URL = "https://api01.iq.questrade.com/v1/accounts"

    def self.data
      HTTParty.get(BASE_URL, headers: self.class.headers, format: :json)
    end

  end
end
