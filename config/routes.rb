Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope 'api/v1/' do
    resource :users, only: [:create] do
      post "/login", to: "users#login"
      get "/auto_login", to: "users#auto_login"
    end

    resource :rides do
      get "/rides", to: "rides#index"
      get "/estimate", to: "rides#estimate"
      post "/starttrip", to: "rides#start_trip"
      post "/endtrip", to: "rides#end_trip"
      get "/latestride", to: "rides#latest_ride"
      post "/updaterating", to: "rides#update_rating"
    end

    resource :drivers do
      get "/get_available_drivers", to: "drivers#get_available_drivers"
    end
  end
end
