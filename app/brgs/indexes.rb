module BRGS
  class Indexes
    extend RedisConnection

    def self.node_count
      redis.hlen 'node'
    end

    def self.source_count
      redis.scard 'sources'
    end

    def self.sources
      redis.smembers 'sources'
    end

    def self.sink_count
      redis.scard 'sinks'
    end

    def self.path_indexes
      redis.hkeys 'path'
    end

    def self.path_count
      redis.hlen 'path'
    end

    def self.template_count
      redis.hlen 'template'
    end

    def self.path path_index
      redis.hget 'path', path_index
    end
  end
end
