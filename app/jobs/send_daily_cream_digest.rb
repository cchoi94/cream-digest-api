class SendDailyCreamDigest
  include Sidekiq::Worker

  def perform
    User.all.each do |u|
      u.integrations.each do |i|
        i.handle_positions_creation(sync_type: "morning")
      end
      DailyCreamDigestMailer.with(user: u).new_cream_digest.deliver_now
    end
  end
end
