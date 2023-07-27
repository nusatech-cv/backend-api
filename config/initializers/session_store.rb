# frozen_string_literal: true

# Use cache_store as session_store for Rails sessions. Key default is '_account_session'
Rails.application.config.session_store :cache_store, key: '_beauty_care', expire_after: 24.hours.seconds, same_site: :none, secure: false