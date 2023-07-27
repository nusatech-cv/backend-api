require 'vault/rails'

Vault::Rails.configure do |config|
  config.enabled = Rails.env.production? || Rails.env.development?
  config.address = ENV.fetch("VAULT_ADDRESS")
  config.token = ENV.fetch("VAULT_TOKEN")
  config.ssl_verify = false
  config.timeout = 60
end

if ENV.fetch('VAULT_TOKEN').to_s != ''
  def renew_process
    token = Vault.auth_token.lookup(Vault.token)
    time = token.data[:ttl] * (1 + rand) * 0.1
    Rails.logger.debug '[VAULT] Token will renew in %.0f sec' % time
    sleep(time)
    Vault.auth_token.renew(token.data[:id])
    Rails.logger.info '[VAULT] Token renewed'
  end

  token = Vault.auth_token.lookup(Vault.token)

  if token.data[:renewable]
    Rails.logger.info '[VAULT] Starting token renew thread'
    Thread.new do
      loop do
        renew_process
      rescue StandardError => e
        report_exception(e)
        sleep 60
      end
    end
  else
    Rails.logger.info '[VAULT] Token is not renewable'
  end
else
  Rails.logger.warn '[ENVIRONMENT] variable VAULT_TOKEN is missing'
  # raise 'FATAL: variable VAULT_TOKEN missing'
end