class UsersController < ApplicationController
    before_action :authorized, only: [:auto_login]
  
    # REGISTER
    def create
      username = params[:username]
      password = params[:password]
      user_type = rand(1..3)
      @user = User.create({username: username, password: password, user_type: user_type})
      if @user.valid?
        token = encode_token({user_id: @user.id})
        return get_user_json(@user, token);
      else
        render json: {error: "Invalid username or password"}
      end
    end
  
    # LOGGING IN
    def login
      @user = User.find_by(username: params[:username])
  
      if @user && @user.authenticate(params[:password])
        token = encode_token({user_id: @user.id})
        return get_user_json(@user, token);
      else
        render json: {error: "Invalid username or password"}
      end
    end
  
  
    def auto_login
      render json: @user.as_json(:except => [:password_digest, :age])
    end

    private
  
    def user_params
      params.permit(:username, :password)
    end
  
    def get_user_json(user, token)
       return render json: {
            :user => user.as_json(:except => [:password_digest]),
            token: token
        }
    end
  end