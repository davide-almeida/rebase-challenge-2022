require 'sidekiq'
require_relative '../workers/csv_worker'

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://redis' }
  # config.redis = { url: 'redis://172.18.0.3:6379' }
end

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://redis' }
  # config.redis = { url: 'redis://172.18.0.3:6379' }
end
