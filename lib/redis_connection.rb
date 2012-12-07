module RedisConnection
  def redis
    @redis_connection ||= Redis::Namespace.new(Settings.redis.namespace, :redis => Redis.new(Settings.redis.to_hash))
  end

  def index collection, item
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

  def destroy_index collection
    redis.del "#{collection}s_count"
    redis.del "#{collection}"
    redis.del "#{collection}_index"
  end
end
