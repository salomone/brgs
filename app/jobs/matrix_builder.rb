# -*- coding: utf-8 -*-

class MatrixBuilder
  extend RedisConnection

  @queue = :matrix_builder

  class << self

    def perform(name, path_index)
      path_string = redis.hget 'path', path_index
      path = path_string.split ','
      template = odds path
      template_string = template.join ','
      ti = index('template', template_string)[0]

      nodes = evens path
      nodes.each_with_index do |node, pos|
        tuple = [pos + 1, path.size, ti].join ','
        redis.hset 'matrix', "#{path_index}:#{node}", tuple
      end

    end

    def odds(a)
      a.values_at(* a.each_index.select {|i| i.odd?})
    end

    def evens(a)
      a.values_at(* a.each_index.select {|i| i.even?})
    end

  end
end
