# -*- coding: utf-8 -*-

class RDFParsing
  include RedisConnection

  @queue = :rdf_parsing

  def self.perform(name, rdf_segment)
    BRGS::Parser.perform name, rdf_segment
  end

end
