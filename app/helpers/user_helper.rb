module UserHelper
    def name_user_params
      {
        first_name: params[:first_name],
        last_name: params[:last_name]
      }
    end
end
  