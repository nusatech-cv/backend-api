# frozen_string_literal: true

module Encryptable
    extend ActiveSupport::Concern
  
    class_methods do
      def attr_encrypted(*attributes)
        attributes.each do |attribute|
          define_method("#{attribute}=") do |value|
            return if value.nil?
  
            self.public_send("#{attribute}_encrypted=", EncryptionService.encrypt(value))
          end
  
          define_method(attribute) do
            value = self.public_send("#{attribute}_encrypted")
            EncryptionService.decrypt(value) if value.present?
          end
        end
      end
    end
  end
  