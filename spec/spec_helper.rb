require 'rspec'
require 'resque'
require 'resque_queue_blocker'
require 'ruby-debug'

RSpec.configure do |config|
  config.after(:each) do
    Resque.redis.flushdb    
  end
end
