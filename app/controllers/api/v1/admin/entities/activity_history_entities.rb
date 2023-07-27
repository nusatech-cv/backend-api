module Api::V1::Admin::Entities
    class ActivityHistoryEntities < Api::V1::Entities::ActivityHistoryEntities
      expose :id,
            documentation: {
              type: 'integer',
              desc: 'identifier for activity history'
            }
      
      with_options(format_with: :iso_timestamp) do
        expose :created_at
        expose :updated_at
      end
    end
end
  