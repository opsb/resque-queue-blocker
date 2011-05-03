# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
require 'resque-queue-blocker/version'
 
Gem::Specification.new do |s|
  s.name        = "resque-queue-blocker"
  s.version     = Resque::Plugins::QueueBlocker::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Oliver Searle-Barnes"]
  s.email       = ["oliver@opsb.co.uk"]
  s.homepage    = "http://github.com/opsb/resque-queue-blocker"
  s.summary     = "When job is in progress block other jobs in same queue from being executed"
  s.has_rdoc    = false
  
  s.add_dependency 'resque', '~>1.0'
  s.add_development_dependency "rspec"
 
  s.files        = Dir.glob("{lib}/**/*") + %w(README.markdown)
  s.require_path = 'lib'

  s.description = "When a job is in progress block other jobs in the same queue from being executed."

end