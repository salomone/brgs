# -*- coding: utf-8 -*-
class GraphSpider
  @queue = :graph_spider

  def self.perform(name)
    BRGS::Walker.destroy_paths_templates_sparse_matrix
    BRGS::Indexes.sources.each do |source|
      Resque.enqueue GraphCrawler, name, source
    end
  end
end
