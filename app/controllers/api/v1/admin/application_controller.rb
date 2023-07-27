class Api::V1::Admin::ApplicationController < ApplicationController
    before_action :authorized
    before_action :is_admin?
end
