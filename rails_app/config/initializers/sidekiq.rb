require "redis"

SENTINELS = [
  { host: "localhost", port: 26379 },
  { host: "localhost", port: 26380 },
  { host: "localhost", port: 26381 },
]

redis_conn = proc do
  Redis.new(host: 'mymaster', sentinels: SENTINELS, role: :master)
end

# redis_conn = proc do
#   Redis.new(url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/1'))
# end

Sidekiq.configure_client do |config|
  config.redis = ConnectionPool.new(size: 30, &redis_conn)
end

Sidekiq.configure_server do |config|
  config.redis = ConnectionPool.new(size: 30, &redis_conn)
end
