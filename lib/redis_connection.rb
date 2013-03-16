module RedisConnection
  def redis
    @redis_connection ||= Redis::Namespace.new(Settings.redis.namespace, :redis => Redis.new(Settings.redis.to_hash.merge(:driver => :hiredis)))
  end
end
