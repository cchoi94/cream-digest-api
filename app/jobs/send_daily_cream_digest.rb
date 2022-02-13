class SendDailyCreamDigest
  include Sidekiq::Worker

  def perform
    User.all.each do |u|
      u.integrations.where(name: 'questrade').first.handle_positions_creation
      DailyCreamDigestMailer.with(user: u).new_cream_digest.deliver_now
    end
  end
end
