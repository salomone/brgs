require 'resque'
require 'resque/tasks'

load 'env.rb' if File.exist? 'env.rb'
require File.expand_path('../config/application', __FILE__)

namespace :resque do
  desc 'Start the Resque-web interface'
  task :web do
    `resque-web --no-launch --foreground --redis #{Settings.resque.host}:#{Settings.resque.port} --namespace #{Settings.resque.namespace}`
  end
end

namespace :brgs do
  desc 'Clears current indexes and indexes paper.nt'
  task :admission, :ntfile do |t, args|
    args.with_defaults(:ntfile => 'example-rdfs/tall/paper.nt')
    Resque.enqueue RDFAdmission, 'paper', args[:ntfile]
  end

  desc 'Clears sparse matrix and builds it from current indexes'
  task :spider do
    Resque.enqueue GraphSpider, 'paper'
  end

  desc 'Prints a path[path_index]'
  task :path, :path_index do |t, args|
    PrintUtils.path args[:path_index]
  end

  task :servers_rb do
    puts NetworkBuilder.servers_rb
  end
end
