require 'resque'
require 'resque/tasks'
require './app/jobs/rdf_admission'

namespace :worker do
    task :start do
        Resque.redis.namespace = "resque:brgs"
        Rake::Task['resque:work'].invoke
    end
end
