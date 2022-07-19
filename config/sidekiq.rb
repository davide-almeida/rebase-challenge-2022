require 'sidekiq'
require_relative '../workers/csv_worker'

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://davide_redis' }
end

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://davide_redis' }
end
