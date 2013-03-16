# -*- coding: utf-8 -*-

class GraphCrawler
  extend RedisConnection

  @queue = :graph_crawler

  class << self

    def perform(name, source)
      walk source
    end

    def index_path path
      path_string = path.join ','
      path_index, path_created = index 'path', path_string
      Resque.enqueue MatrixBuilder, @name, path_index
    end

    def walk source
      queue = []
      marked = []

      queue.push :node => source, :walk => [source]
      marked.push source

      until queue.empty?
        node_walk = queue.shift
        node = node_walk[:node]
        walk = node_walk[:walk]

        edges_from_node = redis.smembers "edges_from_node:#{node}"

        if edges_from_node.empty?
          index_path walk
        else
          edges_from_node.each do |edge_node|
            edge, dest = edge_node.split ','
            unless marked.include? dest
              marked.push dest
              queue.push :node => dest, :walk => walk + [edge, dest]
            end
          end
        end
      end
    end

  end
end
