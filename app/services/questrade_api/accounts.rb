module QuestradeApi
  class Accounts < QuestradeApi::Sync
    def self.get(integration)
      new_headers = headers(integration)
      puts new_headers
      res = HTTParty.get("#{integration.host_server}v1/accounts", headers: new_headers)
      puts "@@@ accounts"
      puts res["accounts"]
      res["accounts"]
    rescue => error
      Rails.logger.error(error.message)
      error
    end
  end
end
