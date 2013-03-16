module BRGS
  class Builder
    extend RedisConnection

    def self.build path_index
      path_string = redis.hget 'path', path_index
      path = path_string.split ','
      template = odds path
      template_string = template.join ','
      ti = index('template', template_string)[0]

      nodes = evens path
      nodes.each_with_index do |node, pos|
        tuple = [pos + 1, nodes.size, ti].join ','
        redis.hset 'matrix', "#{path_index}:#{node}", tuple
      end

    end

    def self.odds(a)
      a.values_at(* a.each_index.select {|i| i.odd?})
    end

    def self.evens(a)
      a.values_at(* a.each_index.select {|i| i.even?})
    end

  end
end
