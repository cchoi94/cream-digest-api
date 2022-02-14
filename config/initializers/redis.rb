module ReadCache
  class << self
    def redis
      @redis = Redis.new(:host => ENV["REDIS_URL"], :port => ENV["REDIS_PORT"])
      @redis.silence_deprecations = true
    end
  end
end