class DailyCreamDigestMailerPreview < ActionMailer::Preview
  def new_cream_digest
    DailyCreamDigestMailer.with(user: User.first).new_cream_digest
  end
end
