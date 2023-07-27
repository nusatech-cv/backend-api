begin
    if Rails.env.production? || Rails.env.development?
        # raise 'FATAL: REDIS_URL is missing'
        unless ENV.fetch('REDIS_URL') == ''
            redis_url = ENV.fetch('REDIS_URL')
            r = Redis.new(url: redis_url)
            r.ping
        end
    end
rescue Redis::CannotConnectError
    Rails.logger.fatal("[Error] connecting to Redis on #{redis_url} (Errno::ECONNREFUSED)")
    raise 'FATAL: connection to Redis refused'
end