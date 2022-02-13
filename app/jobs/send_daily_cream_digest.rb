class SendDailyCreamDigest
  include Sidekiq::Worker

  def perform
    User.all.each do |u|
      DailyCreamDigestMailer.with(user: u).new_cream_digest.deliver_now
    end
  end
end
