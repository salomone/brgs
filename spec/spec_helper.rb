ENV['RACK_ENV'] ||= 'test'
require File.expand_path("#{File.dirname(__FILE__)}/../config/application", __FILE__)

require 'simplecov'
SimpleCov.start

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.order = 'random'
end

require 'ostruct'
