module BRGS
  class Index
    extend RedisConnection

    def self.admission name, contents
      redis.set name, contents
      Resque.enqueue RDFAdmission, name
    end

    def self.spider name
      Resque.enqueue GraphSpider, name
    end

    def self.node_count
      redis.hlen 'node'
    end

    def self.source_count
      redis.scard 'sources'
    end

    def self.sink_count
      redis.scard 'sinks'
    end

    def self.path_count
      redis.hlen 'path'
    end

    def self.path path_index
      redis.hget 'path', path_index
    end
  end
end
