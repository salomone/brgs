require 'rails_config'
RailsConfig.load_and_set_settings 'config/environments/production.yml'

set :application, 'brgs'
set :scm, :none
set :repository, '.'
set :deploy_via, :copy
set :rvm_ruby_string, 'ruby-1.9.3-p194@brgs'
set :remote_bundle, "/home/ubuntu/.rvm/gems/ruby-1.9.3-p194@global/bin/bundle"

set :user, 'ubuntu'
ssh_options[:forward_agent] = true

load File.expand_path('../../servers.rb', __FILE__)

before 'deploy:setup', 'rvm:install_rvm'
before 'deploy:setup', 'rvm:install_ruby'
after 'deploy:setup', 'setup:fixes'
after 'deploy:setup', 'setup:redis_hostname'
after 'deploy:setup', 'setup:redis'

before 'deploy', 'rvm:create_gemset'

def apt_get packages
  sudo "DEBIAN_FRONTEND=noninteractive apt-get -y install #{packages}"
end

namespace :foreman do
  desc "Sets up foreman init"
  task :setup, :roles => :foreman do
    upload 'Procfile.prod', "#{current_path}/Procfile.prod"
    find_servers_for_task(current_task).each do |server|
      run "cd #{current_path} && rvmsudo #{remote_bundle} exec foreman export upstart /etc/init -a #{application} -c '#{server.options[:concurrency]}' -u #{user} -f Procfile.prod", :hosts => server
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

namespace :setup do
  desc 'Creates extra folders ahead of time and resets some permissions'
  task :fixes do
    sudo "chown -R ubuntu:ubuntu #{deploy_to}"
  end

  desc 'Installs and setup redis'
  task :redis, :roles => :redis do
    apt_get 'redis-server'
    sudo 'chown ubuntu:ubuntu /etc/redis/redis.conf'
    upload 'config/redis.conf', '/etc/redis/redis.conf'
    sudo '/etc/init.d/redis-server restart'
  end

  desc 'Sets hostname pointing to redis'
  task :redis_hostname do
    set :ghost, "/home/ubuntu/.rvm/gems/ruby-1.9.3-p194@brgs/bin/ghost"
    run "gem install ghost && rvmsudo #{ghost} delete redis-server && rvmsudo #{ghost} add redis-server #{redis_server}"
  end
end

require 'bundler/capistrano'
require 'rvm/capistrano'
