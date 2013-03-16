require 'resque'
require 'resque/tasks'

load 'env.rb' if File.exist? 'env.rb'
require File.expand_path('../config/application', __FILE__)

def web_server
  ENV['REMOTE'] || 'localhost'
end

def ntfile
  ENV['NTFILE'] || File.expand_path('../example-rdfs/tall/paper.nt', __FILE__)
end

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
  task :admission do |t, args|
    `curl -s -F 'rdf-uri=#{ntfile}' #{web_server}:5678/admission`
  end

  desc 'Clears sparse matrix and builds it from current indexes'
  task :spider do
    `curl -s -X PUT -d '' #{web_server}:5678/spider`
  end

  desc 'Prints a path[path_index]'
  task :path, :path_index do |t, args|
    puts `curl -s #{web_server}:5678/path/#{args[:path_index]}`
  end

  desc 'Prints the indexes'
  task :indexes do
    puts PrintUtils.indexes
  end

  desc 'Prints the sparse matrix'
  task :sparse_matrix do
    puts PrintUtils.sparse_matrix
  end

  task :servers_rb do
    puts NetworkBuilder.servers_rb
  end
end
