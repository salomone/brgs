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

    def self.destroy_sinks_and_sources
      redis.del "out_degree"
      redis.del "in_degree"
      redis.del "sinks"
      redis.del "sources"
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

    def self.update_sinks_and_sources
      nodes_count = redis.get 'nodes_count'

      1.upto(nodes_count.to_i) do |node_index|
        out_degree = redis.hget "out_degree", node_index
        in_degree = redis.hget "in_degree", node_index

        if out_degree.nil? or out_degree==0
          redis.srem 'sources', node_index
          redis.sadd 'sinks', node_index
        else
          if in_degree.nil? or in_degree==0
            redis.sadd 'sources', node_index
            redis.srem 'sinks', node_index
          else
            #has both out and in degrees
            if out_degree.to_i > (10*in_degree.to_i)
              redis.sadd 'sources', node_index
              redis.srem 'sinks', node_index        
            else
              redis.srem 'sources', node_index
            end

            if in_degree.to_i > (10*out_degree.to_i)
              redis.srem 'sources', node_index
              redis.sadd 'sinks', node_index
            else
              redis.srem 'sinks', node_index
            end
          end
        end
      end
     
    end

  end
end
