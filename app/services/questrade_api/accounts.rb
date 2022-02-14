module QuestradeApi
  class Accounts < QuestradeApi::Sync
    
    def self.get(integration)
      BASE_URL = "#{integration.host_server}v1/accounts"
      res = HTTParty.get(BASE_URL, headers: headers(integration))
      res["accounts"]
    rescue => error
      Rails.logger.error(error.message)
      error
    end
  end
end
