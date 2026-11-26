require_relative 'boot'

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"

require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module Judge0API
  class Application < Rails::Application
    config.api_only = true
    config.generators do |g|
      g.factory_girl test_framework: :rspec
    end

    config.active_job.queue_adapter = :sidekiq

    # Deployment runbook (Resque -> Sidekiq cutover):
    # 1. Before deploying, stop new submissions (brief maintenance or drain
    #    window) and let Resque finish its queues:
    #      resque-web   # confirm depth
    #      # workers exit on their own when queues are empty; verify:
    #      redis-cli keys "queue:*"        # only empty list keys should remain
    # 2. If any payloads remain (failed/retry queues), migrate them:
    #      # each Resque payload is an ActiveJob-compatible JSON hash with
    #      # "job_class", "arguments" and "queue" keys; re-enqueue with:
    #      redis-cli lrange "queue:default" 0 -1   # inspect first
    #      # then for each payload r, push it to the Sidekiq queue as Sidekiq
    #      # accepts the same ActiveJob hash:
    #      redis-cli lpush "queue:default" "$r"
    # 3. Deploy this build, then start workers: ./scripts/workers
    # 4. Verify: GET /workers shows subscribed processes and a shrinking
    #    queue size; delete leftover "queue:*" keys once drained.

    config.middleware.insert_before 0, Rack::Cors do
      origins = []

      disallowed_origins = (ENV['DISALLOW_ORIGIN'].to_s.split - ENV['ALLOW_ORIGIN'].to_s.split).collect{ |s| s.gsub(".", "\\.") }.join("|")
      if disallowed_origins.present?
        origins.append(Regexp.new("^(?:(?!#{disallowed_origins}).)*$"))
      end

      # ALLOW_ORIGIN and DISALLOW_ORIGIN are mutually exclusive so this doesn't have any effect.
      origins += (ENV['ALLOW_ORIGIN'].presence || (origins.present? ? '' : '*')).split

      allow do
        origins origins
        resource '*', headers: :any, methods: :any
      end
    end
  end
end
