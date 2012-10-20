require 'rdf'
require 'rdf/ntriples'

class RDFParsing
  @queue = :rdf_parsing

  class << self

    def perform(name, rdf, segment)
      rdf_string = `sed -n #{segment[:first] + 1},#{segment[:last] + 1}p #{rdf}`

      RDF::Reader.for(:ntriples).new(rdf_string) do |reader|
        reader.each_statement do |statement|
          parse_line statement.to_triple
        end
      end
    end

    def parse_line(s, p, o)
    end

  end
end
