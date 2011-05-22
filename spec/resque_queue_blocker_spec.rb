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
    
    it "should include before_perform_with_queue_block in before hooks" do
      Resque::Plugin.before_hooks(RepoJob).map(&:to_s).should include("before_perform_with_queue_block")
    end
    
    it "should remove queue from blocked list in redis when after perform hook is called" do
      Resque.redis.sadd("blocked_queues", "repo1")
      RepoJob.after_perform_with_queue_block
      Resque.redis.sismember("blocked_queues", "repo1").should be_false
    end
    
    it "should include after_perform_with_queue_block in after hooks" do
      Resque::Plugin.after_hooks(RepoJob).map(&:to_s).should include("after_perform_with_queue_block")      
    end
    
    it "should remove queue from blocked list in redis when failure hook is called" do
      Resque.redis.sadd("blocked_queues", "repo1")
      RepoJob.on_failure_with_queue_block
      Resque.redis.sismember("blocked_queues", "repo1").should be_false
    end
    
    it "should include on_failure_with_queue_block in failure hooks" do
      Resque::Plugin.failure_hooks(RepoJob).map(&:to_s).should include("on_failure_with_queue_block")
    end
  end
end