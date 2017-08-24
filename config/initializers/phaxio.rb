Phaxio.config do |config|
  config.api_key = ENV.fetch 'PHAXIO_API_KEY'
  config.api_secret = ENV.fetch 'PHAXIO_API_SECRET'
end
