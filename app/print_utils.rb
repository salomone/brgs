class PrintUtils
  extend RedisConnection

  def self.path path_index
    out = ''
    path_string = redis.hget 'path', path_index
    path = path_string.split ','
    path.each_with_index do |e, i|
      i.even? ? out += redis.hget('node', e) : out += redis.hget('edge', e)
      out += "\n"
    end
    out
  end

end
