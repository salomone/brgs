require 'resque'
require 'resque/tasks'

require File.expand_path("#{File.dirname(__FILE__)}/config/environment", __FILE__)

namespace :worker do
  task :start do
    Resque.redis.namespace = "development:brgs:resque"
    Rake::Task['resque:work'].invoke
  end
end
