require 'resque'
require 'resque/tasks'

require File.expand_path('../config/application', __FILE__)

namespace :resque do
  desc 'Start the Resque-web interface'
  task :web do
    `resque-web --no-launch --foreground --redis #{Settings.redis.host}:#{Settings.redis.port} --namespace #{Settings.redis.namespace}`
  end
end

namespace :paper do
  desc 'Clears current indexes and indexes paper.nt'
  task :admission do
    Resque.enqueue RDFAdmission, 'paper', 'example-rdfs/tall/paper.nt'
  end

  desc 'Clears sparse matrix and builds it from current indexes'
  task :spider do
    Resque.enqueue GraphSpider, 'paper'
  end

  desc 'Prints a path[path_index]'
  task :path, :path_index do |t, args|
    PrintUtils.path args[:path_index]
  end
end
