module BRGS
  class SparseMatrix
    extend RedisConnection

    def self.destroy_matrix
      redis.smembers 'matrix_nodes' do |node|
        redis.del "matrix_node:#{node}"
      end

      redis.smembers 'matrix_paths' do |path|
        redis.del "matrix_path:#{path}"
      end

      redis.del 'matrix_nodes'
      redis.del 'matrix_paths'
    end

    def self.store_position node, path, tuple
      redis.sadd 'matrix_nodes', node
      redis.sadd 'matrix_paths', path

      redis.hset "matrix_node:#{node}", path, tuple
      redis.hset "matrix_path:#{path}", node, tuple
    end

    def self.column node
      redis.hgetall("matrix_node:#{node}")
    end
  end
end
