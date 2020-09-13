class Driver < ApplicationRecord
    enum status: {free: 1, waiting: 2, busy: 3, offline: 4}
end
