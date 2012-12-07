class PrintUtils
  extend RedisConnection

  def self.path path_index
    path_string = redis.hget 'path', path_index
    path = path_string.split ','
    path.each_with_index do |e, i|
      i.even? ? puts(redis.hget('node', e)) : puts(redis.hget('edge', e))
    end
  end

end
