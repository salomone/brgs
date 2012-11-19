# -*- coding: utf-8 -*-

class GraphSpider
  extend RedisConnection

  @queue = :graph_spider

  class << self

    def perform(name)
      destroy_index 'path'
      destroy_index 'template'

      redis.del 'visited_count'
      redis.del 'matrix'

      sources = redis.smembers 'sources'
      sources.each do |source|
        Resque.enqueue GraphCrawler, name, source
      end
    end

  end
end
