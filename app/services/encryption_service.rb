# frozen_string_literal: true

module EncryptionService
    class << self
      def current_salt
        Time.now.strftime('%Y%W')
      end
  
      def pack(salt, value)
        [salt, value].join('.')
      end
  
      def unpack(str)
        raise "Invalid encrypted value: #{str}" unless str =~ (/(\w*)\.(.*)/)
        [$1, $2]
      end
  
      def encrypt(value)
        salt = current_salt
        current_key = get_master_key(salt)
        encrypted_key = encryptor(current_key).encrypt_and_sign(value)
        pack(salt, encrypted_key)
      end
  
      def decrypt(value)
        salt, encrypted_key = unpack(value)
        master_key = get_master_key(salt)
        encryptor(master_key).decrypt_and_verify(encrypted_key)
      end
  
      private
  
      def encryptor(key)
        ActiveSupport::MessageEncryptor.new(key)
      end
  
      def get_master_key(salt)
        @cache ||= {}
        delete_expired_keys
  
        unless @cache[salt]
          @cache[salt] = {}
  
          @cache[salt]['key'] ||= ActiveSupport::KeyGenerator.new(
            ENV['SECRET_KEY_BASE']
          ).generate_key(salt, ActiveSupport::MessageEncryptor.key_len)
  
          @cache[salt]['expire_date'] = 1.week.from_now
        end
  
        @cache[salt]['key']
      end
  
      def delete_expired_keys
        return unless @cache.is_a?(Hash)
  
        @cache.each do |salt, values|
          @cache.delete(salt) if values['expire_date'].present? && values['expire_date'] < Time.now
        end
      end
    end
end
  