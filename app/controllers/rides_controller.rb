class RidesController < ApplicationController
    before_action :authorized

    def get_rides
        @rides = Ride.where(user_id: params[:userId])

        render json: @rides.to_json() 
    end
end
