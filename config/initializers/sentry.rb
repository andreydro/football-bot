# frozen_string_literal: true

# Sentry.init do |config|
#   config.dsn = Rails.application.credentials.sentry_dsn
#   config.breadcrumbs_logger = %i[active_support_logger http_logger]

#   # Set traces_sample_rate to 1.0 to capture 100%
#   # of transactions for performance monitoring.
#   # We recommend adjusting this value in production.
#   config.traces_sample_rate = 1.0
#   # or
#   config.traces_sampler = lambda do |context|
#     true
#   end
# end

Raven.configure do |config|
  config.dsn = if Rails.env.production?
                 Rails.application.credentials.production[:sentry_dsn]
               else
                 Rails.application.credentials.staging[:sentry_dsn]
               end
  config.current_environment = 'production'
end
