module ReadCache
  class << self
    def redis
      @redis = Redis.new(host: ENV["REDISCLOUD_URL"], port: ENV["REDIS_PORT"])
      @redis.silence_deprecations = true
      @redis.exists_returns_integer = true
    end
  end
end
