class DriversController < ApplicationController
    before_action :authorized

    def get_available_drivers
        @drivers = Driver.where(status: 1)

        render json: @drivers.to_json()
    end
end
