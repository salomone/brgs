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

def build_data
  destroy_data
  parse_paper_rdf
  walk_paper_paths
  build_paper_sparse_matrix
  build_path_lenghts
end

def destroy_data
  BRGS::Parser.destroy_indexes
  BRGS::Walker.destroy_paths_templates_sparse_matrix
  BRGS::Statistics.destroy_path_length
  BRGS::Indexes.destroy_sinks_and_sources
end

def parse_paper_rdf
  paper_file = File.open 'spec/assets/paper.nt'
  rdf = paper_file.read
  BRGS::Parser.destroy_indexes
  BRGS::Parser.parse rdf

  update_sink_and_sources
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

def build_path_lenghts
  BRGS::Statistics.path_length
end

def update_sink_and_sources
  BRGS::Indexes.update_sinks_and_sources
end