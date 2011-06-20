require 'spec_helper'

describe ResqueQueueBlocker::Server do
  include Rack::Test::Methods
  
  def app
    Resque::Server.new
  end  
  
  context "get blocked queues" do
    before do
      Resque.enqueue RepoJob
      Resque.redis.sadd("blocked_queues", "repo1")      
      get "/blocked%20queues"
    end
  
    it{ last_response.should be_ok }
    
    it "should have header" do
      last_response.body.should =~ /Blocked queues/
    end
    
    it "should link to blocked queues" do
      last_response.body.should =~ %r{<a href="/queues/repo1" >repo1</a>}
    end
  end
end