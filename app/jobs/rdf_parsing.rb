# -*- coding: utf-8 -*-
class RDFParsing
  extend Resque::Plugins::JobStats
  @queue = :rdf_parsing

  def self.perform(name, rdf_segment)
    BRGS::Parser.parse_segment name, rdf_segment
  end
end
