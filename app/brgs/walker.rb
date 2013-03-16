module BRGS
  class Walker
    extend RedisConnection

    def self.destroy_paths_templates_sparse_matrix
      destroy_index 'path'
      destroy_index 'template'

      redis.del 'visited_count'
      redis.del 'matrix'
    end

    def self.walk source, keep_walking_cb=nil
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
          path_string = walk.join ','
          path_index, path_created = index 'path', path_string
          keep_walking_cb path_index unless keep_walking_cb.nil?
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
