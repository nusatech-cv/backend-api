class Api::V1::Admin::BalanceController < ApplicationController
    def show
        Balance.order(id: :asc)
            .tap { |q| q.where(therapist_id: params[:therapist_id]) }
            .tap { |q| return render json: { balances: q } }
    end
end
