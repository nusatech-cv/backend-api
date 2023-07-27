require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

configuration = ['AWS_SIGNATUR_VERSION', 'AWS_ACCESS_KEY_ID', 'AWS_SECRET_ACCESS_KEY', 'AWS_REGION', 'AWS_ENDPOINT', 'AWS_PATH_SYLE', 'BUCKET_NAME']
configuration.each do |configs|
    if ENV.fetch(configs) == ''
        Rails.logger.warn "[ENVIRONMENT] variable #{configs} is missing"
        # raise "FATAL: variable #{configs} missing"
    end
end

CarrierWave.configure do |config|
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV.fetch("AWS_ACCESS_KEY_ID",""),
      aws_secret_access_key: ENV.fetch("AWS_SECRET_ACCESS_KEY",""),
      region: ENV.fetch("AWS_REGION", "es-west-1"),
      endpoint: ENV.fetch("AWS_ENDPOINT", ""),
      path_style: ENV.fetch("AWS_PATH_SYLE", true)
    }
    config.fog_directory = ENV.fetch("BUCKET_NAME", "")
end
