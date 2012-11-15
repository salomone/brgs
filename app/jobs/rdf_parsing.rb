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
    si, sc = index 'nodes', s
    pi = index 'edges', p
    oi, oc = index 'nodes', o

    redis.sadd "predicate_objects:#{si}", "#{pi},#{oi}"

    redis.sadd 'sources', si if sc
    redis.srem 'sources', oi

    redis.sadd 'sinks', oi if oc
    redis.srem 'sinks', si
  end

  def index(collection, item)
    created = false
    index = redis.hget "#{collection}_to_index", item
    if index.nil?
      index = redis.incr "#{collection}_count"
      redis.hset "#{collection}_to_index", item, index
      redis.hset "#{collection}_from_index", index, item
      created = true
    end

    return index, created
  end

end
