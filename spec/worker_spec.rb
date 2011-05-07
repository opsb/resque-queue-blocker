require 'spec_helper'

describe Resque::Worker do
  context "with 1 blocked queue, 1 available queue" do
    before do
      Resque.redis.sadd(:queues, "repo1")
      Resque.redis.sadd(:queues, "repo2")    
      Resque.redis.sadd("blocked_queues", "repo1")
      @worker = Resque::Worker.new "*"
    end

    it "should filter out blocked queues" do
      @worker.queues.should_not include("repo1")
    end

    it "should include available queues" do
      @worker.queues.should include("repo2")
    end
  end

end