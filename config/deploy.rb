require 'rails_config'
RailsConfig.load_and_set_settings 'config/environments/production.yml'

set :application, 'brgs'
set :scm, :git
set :repository, '.'
set :deploy_via, :copy
# set :rvm_ruby_string, 'ruby-1.9.3-p194@brgs'
# set :remote_bundle, "/home/ubuntu/.rvm/gems/ruby-1.9.3-p194@global/bin/bundle"

set :user, 'ubuntu'
ssh_options[:forward_agent] = true

load File.expand_path('../../servers.rb', __FILE__)

# before 'deploy:setup', 'rvm:install_rvm'
# before 'deploy:setup', 'rvm:install_ruby'
before 'deploy:setup', 'setup:essentials'
after 'deploy:setup', 'setup:fixes'
after 'deploy:setup', 'setup:redis_hostname'
after 'deploy:setup', 'setup:redis'

# before 'deploy', 'rvm:create_gemset'

def apt_get packages
  sudo "DEBIAN_FRONTEND=noninteractive apt-get -y install #{packages}"
end

namespace :foreman do
  desc "Sets up foreman init"
  task :setup, :roles => :foreman do
    upload 'Procfile.prod', "#{current_path}/Procfile.prod"
    find_servers_for_task(current_task).each do |server|
      sudo "foreman export upstart /etc/init -a #{application} -c '#{server.options[:concurrency]}' -u #{user} -f #{current_path}/Procfile.prod", :hosts => server
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
  desc 'Installs build-essential and libs'
  task :essentials do
    sudo 'apt-get update'
    apt_get 'ruby1.9.3 rubygems build-essential libxslt-dev libxml2-dev'
    sudo 'gem install bundle foreman'
  end

  desc 'Resets some permissions'
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
    sudo 'gem install ghost'
    sudo 'ghost delete redis-server'
    sudo "ghost add redis-server #{redis_server}"
    # set :ghost, "/home/ubuntu/.rvm/gems/ruby-1.9.3-p194@brgs/bin/ghost"
    # run "gem install ghost && rvmsudo #{ghost} delete redis-server && rvmsudo #{ghost} add redis-server #{redis_server}"
  end
end

namespace :rake do
  task :default, :roles => :redis do
    run "cd #{current_path} && RACK_ENV=production #{remote_bundle} exec rake #{rake_task}"
  end
end

namespace :remote do
  task :default do
    run "#{cmd}"
  end
end

require 'bundler/capistrano'
# require 'rvm/capistrano'
