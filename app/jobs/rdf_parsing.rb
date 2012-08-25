class RDFParsing
  @queue = :rdf_parsing

  class << self

    def perform(name, rdf, segment)
        puts name, rdf, segment
    end

  end
end
