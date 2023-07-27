require 'grape'
require 'grape-entity'

class Base < Grape::Entity
    format_with(:iso_timestamp) { |t| t.iso8601 if t }
end
