require 'rack'
require 'rspec'
require 'rack/test'
require 'resque'
require 'resque/server'
require 'resque_queue_blocker'
require 'ruby-debug'

if ENV["REDISTOGO_URL"]
  uri = URI.parse(ENV["REDISTOGO_URL"])
  Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end

RSpec.configure do |config|
  config.after(:each) do
    Resque.redis.flushdb    
  end
end

class RepoJob
  @queue = "repo1"
  def perform
    # does nothing
  end
end