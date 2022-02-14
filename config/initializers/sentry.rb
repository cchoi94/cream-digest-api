Sentry.init do |config|
  config.dsn = Rails.application.credentials.dig(:sentry, :dsn)
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # To activate performance monitoring, set one of these options.
  # We recommend adjusting the value in production:
  # set a uniform sample rate between 0.0 and 1.0
  config.traces_sample_rate = 0.2 if Rails.pipe_env.production?

  # seperate environments into dashboard
  config.environments = %w[ production ]
  # or
  config.traces_sampler = lambda do |context|
    true
  end
end