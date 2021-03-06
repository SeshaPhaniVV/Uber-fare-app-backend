class Ride < ApplicationRecord
    belongs_to :user
    belongs_to :driver

    validates :user_id, :driver_id, presence: true
end


class CabNotFound < StandardError
    attr_accessor :message, :options
    def initialize(message=self.class.to_s, options={})
      @message = message
      @options = options
    end
end
