require 'resque'
require 'resque/tasks'

require File.expand_path('../config/application', __FILE__)

namespace :resque do
  desc 'Start the Resque-web interface'
  task :web do
    `resque-web -L -F -N dev:brgs:resque`
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
end
