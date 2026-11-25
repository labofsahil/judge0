threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 8)
process_count = Integer(ENV['RAILS_SERVER_PROCESSES'] || 1)
threads threads_count, threads_count
workers process_count

port ENV['PORT']
environment ENV['RAILS_ENV']

# Preload the app once and fork workers from it: lower memory (CoW) and
# faster worker boot.
preload_app!

# Reuse DB connections across forked workers.
before_fork do
  ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord::Base)
end

plugin :tmp_restart
