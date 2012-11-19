# -*- coding: utf-8 -*-

class RDFParsing
  include RedisConnection

  @queue = :rdf_parsing

  def self.perform(name, rdf_segment)
    new(name, rdf_segment).perform
  end

  def initialize(name, rdf_segment)
    @name = name
    @rdf_segment = rdf_segment
  end

  def perform
    rdf_string = redis.hget 'segments', @rdf_segment
    RDF::Reader.for(:ntriples).new(rdf_string) do |reader|
      reader.each_statement do |statement|
        parse_line(*statement.to_triple)
      end
    end
  end

  def parse_line(s, p, o)
    si, sc = index 'node', s
    pi = index('edge', p)[0]
    oi, oc = index 'node', o

    redis.sadd "edges_from_node:#{si}", "#{pi},#{oi}"

    redis.sadd 'sources', si if sc
    redis.srem 'sources', oi

    redis.sadd 'sinks', oi if oc
    redis.srem 'sinks', si
  end

end
