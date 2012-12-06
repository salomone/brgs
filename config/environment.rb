require 'rubygems'

begin
  require 'bundler/setup'
rescue LoadError
  puts "Bundler is not installed, install it with: gem install bundler"
  exit 1
end

$:.unshift(File.expand_path("..", __FILE__))

ENV['RACK_ENV'] ||= 'development'
Bundler.require :default, ENV['RACK_ENV']
RailsConfig.load_and_set_settings "config/environments/#{ENV['RACK_ENV']}.yml"
