class Questrade < Integration
  belongs_to :integration

  def is_questrade?
  end

  def self.oauth_url
    {message: "Questrade oauth link",
     data: "https://login.questrade.com/oauth2/authorize?client_id=#{Rails.application.credentials.dig(:questrade, :consumer_key)}&response_type=token&redirect_uri=#{ENV['CLIENT_URL']}/integration/questrade"}
  end

end
