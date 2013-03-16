# -*- coding: utf-8 -*-
class GraphCrawler
  @queue = :graph_crawler

  def self.keep_walking(path_index)
    Resque.enqueue MatrixBuilder, @name, path_index
  end

  def self.perform(name, source)
    @name = name
    BRGS::Walker.walk source, keep_walking
  end
end
