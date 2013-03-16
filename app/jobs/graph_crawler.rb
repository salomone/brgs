# -*- coding: utf-8 -*-
class GraphCrawler
  @queue = :graph_crawler

  def self.perform name, source
    BRGS::Walker.walk source do |path_index|
      Resque.enqueue MatrixBuilder, name, path_index
    end
  end
end
