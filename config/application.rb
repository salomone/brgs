require File.expand_path('../environment', __FILE__)

Resque.redis = Redis::Namespace.new(Settings.resque.namespace, :redis => Redis.new(Settings.resque.to_hash))

Dir["#{File.dirname(__FILE__)}/../lib/**/*.rb"].each {|f| require f}
Dir["#{File.dirname(__FILE__)}/../app/**/*.rb"].each {|f| require f}
