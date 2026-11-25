require 'database_cleaner/active_record'

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
    Rails.cache.clear if Rails.cache.respond_to?(:clear)
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
