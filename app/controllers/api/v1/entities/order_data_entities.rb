require_relative 'base.rb'
module Api
  module V1
    module Entities
        class OrderDataEntities < Base
            with_options(format_with: :iso_timestamp) do
              expose :created_at
            end
        end
    end
  end
end
  