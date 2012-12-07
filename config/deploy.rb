require 'rails_config'
RailsConfig.load_and_set_settings 'config/environments/production.yml'

set :application, 'brgs'
set :scm, :none
set :repository, '.'
set :deploy_via, :copy
set :rvm_ruby_string, 'ruby-1.9.3-p194@brgs'

set :user, 'ubuntu'
ssh_options[:forward_agent] = true

load File.expand_path('../../servers.rb', __FILE__)

before 'deploy:setup', 'rvm:install_rvm'
before 'deploy:setup', 'rvm:install_ruby'
after 'deploy:setup', 'deploy:more_setup'
after 'deploy:setup', 'deploy:setup_redis_server'

before 'deploy', 'rvm:create_gemset'

namespace :foreman do
  set :foreman_bundle, "/home/ubuntu/.rvm/gems/ruby-1.9.3-p194@global/bin/bundle"

  desc "Sets up foreman init"
  task :setup, :roles => :foreman do
    find_servers_for_task(current_task).each do |server|
      upload "Procfile.prod", "#{current_path}/Procfile.prod"
      run "cd #{current_path} && rvmsudo #{foreman_bundle} exec foreman export upstart /etc/init -a #{application} -c '#{server.options[:concurrency]}' -u #{user} -f Procfile.prod"
    end
  end

  desc "Asks foreman to restart"
  task :restart, :roles => :foreman do
    sudo "restart #{application}"
  end

  desc "Asks foreman to start"
  task :start, :roles => :foreman do
    sudo "start #{application}"
  end

  desc "Asks foreman to stop"
  task :stop, :roles => :foreman do
    sudo "stop #{application}"
  end

  after 'deploy', 'foreman:setup'
  after 'deploy', 'foreman:restart'
  after 'deploy:cold', 'foreman:setup'
  after 'deploy:cold', 'foreman:start'
end

namespace :deploy do
  desc 'Creates extra folders ahead of time and resets some permissions'
  task :more_setup do
    sudo "chown -R ubuntu:ubuntu #{deploy_to}"
  end

  desc 'Installs and setup redis'
  task :setup_redis_server, :roles => :redis do
    sudo 'DEBIAN_FRONTEND=noninteractive apt-get -y install redis-server'
  end
end

require 'bundler/capistrano'
require 'rvm/capistrano'
