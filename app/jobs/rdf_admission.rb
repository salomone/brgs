# -*- coding: utf-8 -*-
class RDFAdmission
  extend Resque::Plugins::JobStats
  @queue = :rdf_admission

  def self.perform rdf_content
    BRGS::Parser.destroy_indexes
    BRGS::Walker.destroy_paths_templates_sparse_matrix
    BRGS::Parser.segments rdf_content do |segment|
      Resque.enqueue RDFParsing, name, segment[:first]
    end
  end
end
