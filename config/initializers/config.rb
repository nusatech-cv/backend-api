# frozen_string_literal: true

require 'beautycare/app'

Beautycare::APP.define do |config|
  config.set(:LOG_LEVEL, 'debug', type: :string)
end
