# -*- coding: utf-8 -*-
class RDFAdmission
  extend RedisConnection

  @queue = :rdf_admission

  class << self

    def perform(rdf)
      BRGS::Parser.destroy_indexes

      FileSplitter.segment(rdf).each do |segment|
        piece = FileSplitter.piece rdf, segment
        redis.hset 'segments', segment[:first], piece
        Resque.enqueue RDFParsing, name, segment[:first]
      end
    end

  end
end
