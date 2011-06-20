module ResqueQueueBlocker
  module Server
    def self.included(base)
      base.class_eval do
        get '/blocked queues' do
          erb File.read(File.join(File.dirname(__FILE__), 'server/views/blocked_queues.erb'))
        end
        
        post '/blocked queues/:repo/delete' do
          Resque::Plugins::QueueBlocker.unblock params[:repo]
          redirect u("blocked%20queues")
        end
      end
    end
  end
  
  Resque::Server.tabs << 'Blocked queues'
end