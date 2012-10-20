# -*- coding: utf-8 -*-

class RDFParsing
  include RedisConnection

  @queue = :rdf_parsing

  def self.perform(name, rdf_string)
    new(name, rdf_string).perform
  end

  def initialize(name, rdf_string)
    @name = name
    @rdf_string = rdf_string
  end

  def perform
    RDF::Reader.for(:ntriples).new(@rdf_string) do |reader|
      reader.each_statement do |statement|
        parse_line(*statement.to_triple)
      end
    end
  end

  def parse_line(s, p, o)
    redis.sadd 'nodes', s
    redis.sadd 'nodes', o
  end

end
