require_relative 'base.rb'
module Api
  module V1
    module Entities
        class TherapistEntities < Base
            expose :id,
                documentation: {
                    type: 'integer',
                    desc: 'user id',
                  }
                
            expose :user_id,
                  documentation: {
                    type: 'integer',
                    desc: 'user id',
                  }
        
            expose :location,
                  documentation: {
                    type: 'string',
                    desc: 'location point'
                  } do |therapist|
                    therapist.location_point_parsing
                  end
        
            expose :photo,
                documentation: {
                    type: 'string',
                    desc: 'photo therapist'
                }
        
            expose :day_start,
                    as: :start_day,
                    documentation: {
                        type: 'integer',
                        desc: 'integer array star day'
                    }
            expose :day_end,
                    as: :end_day,
                    documentation: {
                        type: 'integer',
                        desc: 'integer array star day'
                    }
            
            expose :working_start,
                    as: :start_time,
                    documentation: {
                        type: 'integer',
                        desc: 'integer array star working'
                    } do |therapist|
                        therapist.format_time(therapist.working_start)
                    end
                    
            expose :working_end,
                    as: :end_time,
                    documentation: {
                        type: 'integer',
                        desc: 'integer array star day'
                    } do |therapist|
                        therapist.format_time(therapist.working_end)
                    end
        
            expose :experience_years,
                documentation: {
                    type: 'date',
                    desc: 'birthdate of therapist'
                }
        
            expose :birthdate,
                documentation: {
                    type: 'date',
                    desc: 'birthdate of therapist'
                }
            
            expose :gender,
                documentation: {
                    type: 'string',
                    desc: 'gender therapist male or female'
                }
        
            expose :average_rating,
                documentation: {
                    type: 'string',
                    desc: 'User Therapist data'
                } do |therapist|
                    therapist.count_rating
                end
                
            expose :is_available,
                documentation: {
                    type: 'boolean',
                    desc: 'is available for doing therapist'
                }
          end
    end
  end
end
  