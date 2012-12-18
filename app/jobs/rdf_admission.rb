# -*- coding: utf-8 -*-
require 'tempfile'

class RDFAdmission
  extend RedisConnection

  @queue = :rdf_admission

  class << self

    def perform(name)
      rdf_file = Tempfile.new name
      rdf_content = redis.get name
      rdf_file.write rdf_content
      rdf = rdf_file.path
      rdf_file.close

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

      rdf_file.unlink
    end

  end
end
