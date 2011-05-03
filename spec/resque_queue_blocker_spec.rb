require 'spec_helper'

class RepoJob
  @queue = "repo1"
  def perform
    # does nothing
  end
end

describe Resque::Plugins::QueueBlocker do
  context "when included in a job's class" do
    before do
      RepoJob.send :extend, Resque::Plugins::QueueBlocker
    end
    
    it "should add queue to blocked queues list in redis when before perform hook is called" do
      RepoJob.before_perform_with_queue_block
      Resque.redis.sismember("blocked_queues", "repo1").should be_true
    end
    
    it "should remove queue from blocked list in redis when after perform hook is called" do
      Resque.redis.sadd("blocked_queues", "repo1")
      RepoJob.after_perform_with_queue_block
      Resque.redis.sismember("blocked_queues", "repo1").should be_false
    end
    
    it "should remove queue from blocked list in redis when failure hook is called" do
      Resque.redis.sadd("blocked_queues", "repo1")
      RepoJob.on_failure_with_queue_block
      Resque.redis.sismember("blocked_queues", "repo1").should be_false
    end    
  end
end