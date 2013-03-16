module BRGS
  class Indexes
    extend RedisConnection

    def self.get collection, index
      return redis.hget "#{collection}", index
    end

    def self.find_index collection, item
      return redis.hget "#{collection}_index", item
    end

    def self.index collection, item
      created = false
      index = redis.hget "#{collection}_index", item
      if index.nil?
        index = redis.incr "#{collection}s_count"
        redis.hset "#{collection}", index, item
        redis.hset "#{collection}_index", item, index
        created = true
      end

      return index, created
    end

    def self.destroy_index collection
      redis.del "#{collection}s_count"
      redis.del "#{collection}"
      redis.del "#{collection}_index"
    end

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
