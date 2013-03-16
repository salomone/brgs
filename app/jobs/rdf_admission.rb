# -*- coding: utf-8 -*-
require 'tempfile'

class RDFAdmission
  extend RedisConnection

  @queue = :rdf_admission

  def self.perform rdf_content
    BRGS::Parser.destroy_indexes

    rdf_file = Tempfile.new name
    rdf_file.write rdf_content
    rdf = rdf_file.path
    rdf_file.close

    FileSplitter.segment(rdf).each do |segment|
      piece = FileSplitter.piece rdf, segment
      redis.hset 'segments', segment[:first], piece
      Resque.enqueue RDFParsing, name, segment[:first]
    end
  end
end
