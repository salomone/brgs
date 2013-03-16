module BRGS
  class Parser
    extend RedisConnection

    def self.destroy_indexes
      nodes_count = redis.get 'nodes_count'
      1.upto(nodes_count.to_i) do |n|
        redis.del "edges_from_node:#{n}"
      end

      destroy_index 'node'
      destroy_index 'edge'

      redis.del 'sources'
      redis.del 'sinks'
      redis.del 'segments'
    end

    def self.parse_segment(name, rdf_segment)
      @name = name
      @rdf_segment = rdf_segment
      rdf_string = redis.hget 'segments', @rdf_segment
      parse rdf_string
    end

    def self.parse rdf_string
      rdf_string.each_line do |line|
        matches = line.match(/<(.*)> <(.*)> ([<"])(.*)[>"] \./)
        if matches
          s = matches[1]
          p = matches[2]
          o = matches[4]
          o_literal = matches[3] == '"'
          parse_line(s, p, o, o_literal)
        end
      end
    end

    def self.parse_line(s, p, o, o_literal)
      si, sc = index 'node', s
      pi = index('edge', p)[0]
      oi, oc = index 'node', o

      redis.sadd "edges_from_node:#{si}", "#{pi},#{oi}"

      redis.sadd 'sources', si if sc
      redis.srem 'sources', oi

      redis.sadd 'sinks', oi if oc && o_literal
      redis.srem 'sinks', si
    end

  end
end
