require 'resque'
require "./app/jobs/rdf_parsing"
require "./lib/file_splitter"

class RDFAdmission
  @queue = :rdf_admission

  class << self

    def perform(name, rdf)
      FileSplitter.split(rdf).each do |segment|
        Resque.enqueue(RDFParsing, name, rdf, segment)
      end
    end

  end
end
