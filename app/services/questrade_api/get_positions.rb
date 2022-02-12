module QuestradeApi
  class GetPositions < QuestradeApi::Base
  end

  private

  def base_url(account_id)
    "https://api01.iq.questrade.com/v1/accounts/#{account_id}/positions"
  end
end
