class RidesController < ApplicationController
    before_action :authorized

    def initialize
        @@PER_KM_RATE = 10
        @@VEHICLE_SPEED_KMPH = 30
      end

    def show
        @rides = Ride.where(user_id: params[:user_id]).where.not({ride_end_time: nil})

        render json: @rides.to_json()
    end

    def estimate
        kilometers = params[:kms].to_i
        fare = _getFare(kilometers);

        if (fare < 50)
            fare = 50
        end

        render json: { estimated_fare: fare }
    end

    def latest_ride
        user_id = params[:user_id];
        ride = Ride.where({ride_end_time: nil, user_id: user_id}).last

        render json: ride.as_json
    end

    def create
        begin
            time = Time.now.getutc;
            user_id = params[:user_id];
            kilometers = params[:kms].to_i

            user = User.find(user_id);
            driver = _getAvailableDriver(user.user_type)
            total_minutes =  ((kilometers / @@VEHICLE_SPEED_KMPH) * 60).to_i

            puts driver;

            ride_estimated_end_time = time + total_minutes.minutes

            @ride = Ride.create({user_id: user_id, driver_id: driver.id, ride_book_time: time, ride_estimated_end_time: ride_estimated_end_time})
            driver.update({status: 2})
            user.update({is_riding: true})

            user.save!
            driver.save!

           return render json: @ride.as_json

        rescue ActiveRecord::RecordNotFound => exception
            render json: {error_message: exception.message,}
        rescue CabNotFound => exception
            end_time = _getEndTime()
            render json: {error_message: exception.message, end_time: end_time}
        end
    end

    def start_trip
        begin
            time = Time.now.getutc;
            user_id = params[:user_id];
            ride = Ride.where({ride_end_time: nil, user_id: user_id}).last
            user = User.find(user_id);
            driver = Driver.find(ride.driver_id)

            ride.update({ride_start_time: time})
            driver.update({status: 3})
            user.update({is_riding: true})

            user.save!
            driver.save!
            ride.save!

           return render json: ride.as_json

        rescue ActiveRecord::RecordNotFound => exception
            puts exception
            render json: {error_message: exception.message,}
            rescue CabNotFound => exception
            end_time = _getEndTime()
            render json: {error_message: exception.message, end_time: end_time}
        end
    end

    def end_trip
        begin
            time = Time.now.getutc;
            user_id = params[:user_id];
            @ride = Ride.where({ride_end_time: nil, user_id: user_id}).last
            @driver = Driver.find(@ride.driver_id)
            @user = User.find(@ride.user_id)

            wait_minutes = ((@ride.ride_start_time - @ride.ride_book_time).to_i / 60) + 5

            trip_minutes = ((time - @ride.ride_start_time).to_i / 60)

            fare_amount = 0;

            if (wait_minutes > 4) 
                fare_amount = (wait_minutes - 4).to_i * 10;
            end

            kilometers = ((trip_minutes / 60).to_f * @@VEHICLE_SPEED_KMPH).to_i

            fare_amount += _getFare(kilometers)

            if (fare_amount < 50) 
                fare_amount = 50
            end

            @ride.update({ride_end_time: time, fare: fare_amount})
            @driver.update({status: 1, rides_count: @driver.rides_count + 1})
            @user.update({is_riding: false, rides_count: @user.rides_count + 1})

            @user.save
            @ride.save
            @driver.save

            render json: @ride.as_json
        rescue ActiveRecord::RecordNotFound  => exception
            render json: {error_message: exception.message}
        end
    end

    def update_rating
        begin
            ride_id = params[:ride_id];
            rating = params[:rating].to_i;
            @ride = Ride.find(ride_id)
            @driver = Driver.find(@ride.driver_id)

            avg = @driver.rating == -1 ? rating : (rating + @driver.rating) / 2; 
            @ride.update({rating: rating})
            @driver.update({rating: avg, ratings_count: @driver.ratings_count + 1})

            if (avg < 4 && @driver.rides_count > 5)
                @driver.update({status: 4})
            end

            @ride.save!
            @driver.save!
            render json: { data: 'Thankyou' }

        rescue ActiveRecord::RecordNotFound  => exception
            render json: {error_message: exception.message}
        end
    end

    def _getFare(kilometers)
        surge = 1

        @drivers = Driver.free

        if (@drivers.count == 0)
            render json: {error_message: 'No Cabs available at the moment'}
        end
    
        if (@drivers.count == 2) 
             surge = 1.2;
        end

        if (@drivers.count == 1)
             surge = 1.4;
        end

        total_minutes =  (kilometers / @@VEHICLE_SPEED_KMPH) * 60

        return surge * kilometers * @@PER_KM_RATE + total_minutes;
    end

    def _getAvailableDriver(user_status)
        @drivers = Driver.free

        if (@drivers.count === 0)
            raise CabNotFound.new('No cabs are available right now');
        end
        
        platinum_drivers = @drivers.select { |x| x.rides_count < 5 || x.rating > 4.8 }
        gold_drivers = @drivers.select{ |x| x.rating > 4.5 || x.rides_count < 5 }
        silver_drivers = @drivers.select{ |x| x.rating > 4 || x.rides_count < 5 }

        driver_pool = [platinum_drivers, gold_drivers, silver_drivers]

        case user_status
        when 'platinum'
            start_index = 0;
        when 'silver'
            start_index = 1;
        else
            start_index = 2;
        end


        for i in start_index..2 
            puts driver_pool
            puts i
            return driver_pool[i].sample if driver_pool[i].count != 0
        end
    end

    def _getEndTime
        @drivers = Driver.free
        if (@drivers.count != 0) 
            return 0;
        end

        return @drivers.order(:ride_end_time).first().endtime;
    end
end


class CabNotFound < StandardError
    attr_accessor :message, :options
    def initialize(message=self.class.to_s, options={})
      @message = message
      @options = options
    end
end