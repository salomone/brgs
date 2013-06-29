# -*- coding: utf-8 -*-
require 'open-uri'

class RDFAdmission
  extend Resque::Plugins::JobStats
  @queue = :rdf_admission

  def self.perform uri
   
    rdf_content = open(uri).read
    BRGS::Parser.destroy_indexes
    BRGS::Walker.destroy_paths_templates_sparse_matrix
    BRGS::Statistics.destroy_path_length
    BRGS::Indexes.destroy_sinks_and_sources
    BRGS::Parser.segments rdf_content do |segment|
      Resque.enqueue RDFParsing, name, segment[:first]
    end
  end
end
