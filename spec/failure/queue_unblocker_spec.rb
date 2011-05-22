require 'spec_helper'

describe Resque::Failure::QueueUnblocker do
	
	it "should unblock the queue" do
	  exception = StandardError.new("BOOM")
    worker = Resque::Worker.new(:test)
    queue = "repo1"

		Resque.redis.sadd("blocked_queues", "repo1")

    backend = Resque::Failure::QueueUnblocker.new(exception, worker, queue, {})
    backend.save

		Resque.redis.sismember("blocked_queues", "repo1").should be_false
	end
end