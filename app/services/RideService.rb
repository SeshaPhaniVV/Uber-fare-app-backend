class RideService

    def getAvailableDriver(user_status)
        @drivers = Driver.free

        if (@drivers.count === 0) raise CabNotFound.new('No cabs are available right now');
        
        platinum_drivers = @drivers.select { |x| x.rating > 4.8 }
        gold_drivers = @drivers.select{ |x| x.rating > 4.5 }
        silver_drivers = @drivers.select{ |x| x.rating > 4 }

        driver_pool = [platinum_drivers, gold_drivers, silver_drivers]

        case user_status
        when 'platinum'
            start_index = 0;
        when 'silver'
            start_index = 1;
        else
            start_index = 2;

        for (i = start_index; i < 3; i++) {
            if (driver_pool[i].count === 0) continue;
            return driver_pool[i].sample
        }
    end

    def getEndTime
        @drivers = Driver.free
        if (@drivers.count !== 0) return 0;
        return @drivers.order(:ride_end_time).first().endtime;
    end
end