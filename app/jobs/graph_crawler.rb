# -*- coding: utf-8 -*-

class GraphCrawler
  extend RedisConnection

  @queue = :graph_crawler

  class << self

    def perform(name, source)
      dive [source], Set.new
    end

    def index_path path
      path_string = path.join ','
      index 'path', path_string
    end

    def dive path, marked=nil
      node = path.last
      marked.add node
      node_value = redis.hget 'node', node

      unless node_value.empty?
        edges_from_node = redis.smembers "edges_from_node:#{node}"

        if edges_from_node.empty?
          index_path path
        else
          edges_from_node.each do |edge_node|
            edge, dest = edge_node.split ','
            unless marked.include? dest
              path.push edge, dest
              dive path, marked 
              path.pop 2
            end
          end
        end

        marked.delete node
      end
    end

  end
end
