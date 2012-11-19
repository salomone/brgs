# -*- coding: utf-8 -*-

class GraphCrawler
  extend RedisConnection

  @queue = :graph_crawler

  class << self

    def perform(name, source)
      walk source
      # dive [source]
      # paths_from source
    end

    def index_path path
      path_string = path.join ','
      index 'path', path_string
    end

    def paths_from node, paths={}, marked=nil, walk=nil
      if paths.has_key? node
        paths[node].each do |path|
          full_path = walk[0..-2] + path
          index_path full_path
        end
        return paths[node]
      end

      paths[node] = []
      walk = [node] if walk.nil?

      marked = Set.new if marked.nil?
      marked.add node

      edges_from_node = redis.smembers "edges_from_node:#{node}"

      if edges_from_node.empty?
        paths[node] << [node]
        index_path walk
      else
        edges_from_node.each do |edge_node|
          edge, dest = edge_node.split ','
          unless dest.empty? or marked.include? dest
            dest_paths = paths_from dest, paths, marked, walk + [edge, dest]

            dest_paths.each do |dest_path|
              paths[node] << [node, edge] + dest_path
            end
          end
        end
      end

      marked.delete node
      return paths[node]
    end

    def dive path, marked=nil
      node = path[-1]
      marked = Set.new if marked.nil?

      marked.add node

      node_value = redis.hget 'node', node

      unless node_value.empty?
        edges_from_node = redis.smembers "edges_from_node:#{node}"

        if edges_from_node.empty?
          index_path path
        else
          edges_from_node.each do |edge_node|
            edge, dest = edge_node.split ','
            dive path + [edge, dest], marked unless marked.include? dest
          end
        end

        marked.delete node
      end
    end

    def walk source
      queue = []
      marked = []

      queue.push node: source, walk: [source]
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
              queue.push node: dest, walk: walk + [edge, dest]
            end
          end
        end
      end
    end

  end
end
