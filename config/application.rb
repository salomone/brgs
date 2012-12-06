require File.expand_path('../environment', __FILE__)
Dir["#{File.dirname(__FILE__)}/../lib/**/*.rb"].each {|f| require f}
Dir["#{File.dirname(__FILE__)}/../app/**/*.rb"].each {|f| require f}
