Sentry.init do |config|
  config.dsn = Rails.application.credentials.dig(:sentry, :dsn)
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # To activate performance monitoring, set one of these options.
  # We recommend adjusting the value in production:
  # set a uniform sample rate between 0.0 and 1.0
  config.traces_sample_rate = 0.5

  # seperate environments into dashboard
  config.environment = Rails.env
  # or
  config.traces_sampler = lambda do |context|
    true
  end
end

Raven.configure do |config|
  # Raven reports on the following environments
  config.environments = %w(production)
  # Sentry respects the sanitized fields specified in:
  # config/initializers/filter_parameter_logging.rb
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
  # Raven sends events asynchronous to sentry, using the jobs/sentry_job.rb
  config.async = lambda { |event| SentryJob.perform_later(event) }
  # Overwrite excluded exceptions
  config.excluded_exceptions = []
end