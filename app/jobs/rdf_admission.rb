# -*- coding: utf-8 -*-

class RDFAdmission
  extend RedisConnection

  @queue = :rdf_admission

  class << self

    def perform(name, rdf)
      nodes_count = redis.get 'nodes_count'
      1.upto(nodes_count.to_i) do |n|
        redis.del "edges_from_node:#{n}"
      end

      destroy_index 'nodes'
      destroy_index 'edges'

      redis.del 'sources'
      redis.del 'sinks'
      redis.del 'segments'

      FileSplitter.segment(rdf).each do |segment|
        piece = FileSplitter.piece rdf, segment
        redis.hset 'segments', segment[:first], piece
        Resque.enqueue RDFParsing, name, segment[:first]
      end
    end

  end
end
