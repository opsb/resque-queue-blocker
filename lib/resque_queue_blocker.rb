module Resque
  module Plugins
    module QueueBlocker
      def before_perform_with_queue_block(*args)
        queue = Resque.queue_from_class(self, *args)
        Resque.redis.sadd "blocked_queues", queue
      end
      
      def after_perform_with_queue_block(*args)
        queue = Resque.queue_from_class(self, *args)
        Resque.redis.srem "blocked_queues", queue                
      end
      alias_method :on_failure_with_queue_block, :after_perform_with_queue_block
    end
  end
  
  class Worker
    def queues
      ( @queues[0] == "*" ? Resque.queues.sort : @queues ) - blocked_queues
    end
    
    private
    def blocked_queues
      redis.smembers("blocked_queues")
    end
  end
end