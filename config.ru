require 'sidekiq'
require 'sidekiq/web'
require 'securerandom'

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://davide_redis' }
end

# File.open(".session.key", "w") {|f| f.write(SecureRandom.hex(32)) }
session_key = SecureRandom.hex(32)
use Rack::Session::Cookie, secret: session_key, same_site: true, max_age: 86400
run Sidekiq::Web
