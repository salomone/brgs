module BRGS
  class Statistics
    extend RedisConnection

    def self.path_length 
      destroy_path_length

      paths_count = redis.get 'paths_count'

      1.upto(paths_count.to_i) do |path_index|
        path_string = redis.hget 'path' , "#{path_index}"
        length = path_string.split(',').size
        size = (length/2)+1
        index = redis.hget "path_length", size.to_s
  
        if index.nil?
          redis.hset "path_length", size.to_s, 1
        else
          redis.hincrby "path_length", size.to_s ,1
        end
      end

    end

    def self.incr_path_length length
      index = redis.hget "path_length", length.to_s
  
        if index.nil?
          redis.hset "path_length", length.to_s, 1
        else
          redis.hincrby "path_length", length.to_s ,1
        end
    end

    def self.destroy_path_length
      redis.del "path_length"
    end

  end
end
