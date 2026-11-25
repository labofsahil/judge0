require "sidekiq"
require "sidekiq/api"

Sidekiq.configure_server do |config|
  config.redis = {
    host:     ENV["REDIS_HOST"],
    port:     ENV["REDIS_PORT"],
    password: ENV["REDIS_PASSWORD"],
    size:     Integer(ENV["RAILS_MAX_THREADS"] || 10)
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    host:     ENV["REDIS_HOST"],
    port:     ENV["REDIS_PORT"],
    password: ENV["REDIS_PASSWORD"],
    size:     Integer(ENV["RAILS_MAX_THREADS"] || 10)
  }
end

if ENV["SIDEKIQ_NAMESPACE"].present?
  Sidekiq.redis { |c| c.ns = ENV["SIDEKIQ_NAMESPACE"] }
end
