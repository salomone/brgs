require 'resque'
require 'resque/tasks'

load 'env.rb' if File.exist? 'env.rb'
require File.expand_path('../config/application', __FILE__)

namespace :resque do
  desc 'Start the Resque-web interface'
  task :web do
    require 'vegas'
    Vegas::Runner.new Resque::Server, 'BRGS' do |runner, opts, app|
      runner.options[:skip_launch] = true
      runner.options[:foreground] = true
    end
  end
end

namespace :brgs do
  desc 'Clears current indexes and indexes paper.nt'
  task :admission, :ntfile do |t, args|
    args.with_defaults(:ntfile => 'example-rdfs/tall/paper.nt')
    `curl -s -F 'rdf=@#{args[:ntfile]}' localhost:5678/admission`
  end

  desc 'Clears sparse matrix and builds it from current indexes'
  task :spider do
    `curl -s -X PUT -d '' localhost:5678/spider`
  end

  desc 'Prints a path[path_index]'
  task :path, :path_index do |t, args|
    puts `curl -s localhost:5678/path/#{args[:path_index]}`
  end

  task :servers_rb do
    puts NetworkBuilder.servers_rb
  end
end
