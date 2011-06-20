require 'resque'
require 'resque/server'
require 'resque_queue_blocker/queue_blocker.rb'
require 'resque_queue_blocker/failure/queue_unblocker.rb'
require 'resque_queue_blocker/server'

Resque::Server.class_eval do
  include ResqueQueueBlocker::Server
end