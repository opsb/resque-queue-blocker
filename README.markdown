Resque Queue Blocker
====================

A Resque plugin. Requires https://github.com/alg/resque fork. 

If you want a job to block a queue until it's finished, extend it with this module.

For example:

		require 'resque_queue_blocker'
		
		class SelfishJob
			extend Resque::Plugins::QueueBlocker
			@queue = "selfish_jobs"
			
			def self.perform(email)
				lock_resource(x)
				use_resource(x)
				release_resource(x)
			end
		end
		
When a SelfishJob is being run it will block any other jobs in the "selfish_jobs" queue. Other jobs in this queue will be blocked regardless of whether or not they extend Resque::Plugins::QueueBlocker.

Failure Backend
---------------

It is necessary to use `Resque::Failure::QueueUnblocker` as a failure backend in order to avoid locking up the queues.

Example use with the default failure backend `Resque::Failure::Redis`:

``` ruby
  require 'resque/failure/multiple'
  require 'resque/failure/redis'

  Resque::Failure::Multiple.classes = [Resque::Failure::Redis, Resque::Failure::QueueUnblocker]
  Resque::Failure.backend = Resque::Failure::Multiple
```