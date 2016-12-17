Airbrake.configure do |config|
  config.host = 'http://error.pooul.cn'
  config.project_id = 1 # required, but any positive integer works
  config.project_key = '41da649b9409545aa82382798d7cdc96'

  # Uncomment for Rails apps
  config.environment = Rails.env
  config.ignore_environments = %w(development test)
end
