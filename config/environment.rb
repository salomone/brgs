require 'rubygems'

begin
  require 'bundler/setup'
rescue LoadError
  puts "Bundler is not installed, install it with: gem install bundler"
  exit 1
end

ENV['RACK_ENV'] ||= 'development'

Bundler.require :default, ENV['RACK_ENV']

Dir["#{File.dirname(__FILE__)}/../app/**/*.rb"].each {|f| require f}
Dir["#{File.dirname(__FILE__)}/../lib/**/*.rb"].each {|f| require f}
