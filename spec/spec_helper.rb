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

def parse_paper_rdf
  paper_file = File.open 'spec/assets/paper.nt'
  rdf = paper_file.read
  BRGS::Parser.destroy_indexes
  BRGS::Parser.parse rdf
end

def walk_paper_paths
  BRGS::Walker.destroy_paths_templates_sparse_matrix
  BRGS::Indexes.sources.each do |source|
    BRGS::Walker.walk source
  end
end

def build_paper_sparse_matrix
  BRGS::Indexes.path_indexes.each do |path_index|
    BRGS::Builder.build path_index
  end
end
