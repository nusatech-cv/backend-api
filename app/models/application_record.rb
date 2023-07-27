require 'date'
include RabbitmqHelper
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
