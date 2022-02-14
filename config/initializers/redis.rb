Redis.new(:host => ENV["REDIS_URL"], :port => ENV["REDIS_PORT"])
Redis.silence_deprecations = true