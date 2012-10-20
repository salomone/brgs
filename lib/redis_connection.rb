module RedisConnection
  def redis
    @redis_connection ||= Redis::Namespace.new("#{ENV['RACK_ENV']}:bgrs")
  end
end
