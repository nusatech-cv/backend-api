require 'google/apis/people_v1'
require 'googleauth'

# Set the redirect URI for OAuth authorization
Google::Apis::ClientOptions.default.application_name = 'local-dev'
Google::Apis::ClientOptions.default.application_version = '1.0'
