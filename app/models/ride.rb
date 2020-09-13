class Ride < ApplicationRecord
    belongs_to :user
    belongs_to :driver

    validates :user_id, :driver_id, presence: true
end
