class User < ApplicationRecord
    enum user_type: {silver: 1, gold: 2, platinum: 3}
    has_secure_password
end
