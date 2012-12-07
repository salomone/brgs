require File.expand_path('../environment', __FILE__)

Resque.redis = Redis::Namespace.new(Settings.redis.namespace, :redis => Redis.new(Settings.redis.to_hash))

Dir["#{File.dirname(__FILE__)}/../lib/**/*.rb"].each {|f| require f}
Dir["#{File.dirname(__FILE__)}/../app/**/*.rb"].each {|f| require f}
