# -*- coding: utf-8 -*-

class RDFAdmission
  @queue = :rdf_admission

  class << self

    def perform(name, rdf)
      FileSplitter.segment(rdf).each do |segment|
        Resque.enqueue(RDFParsing, name, rdf, segment)
      end
    end

  end
end
