Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope 'api/v1/' do
    resource :users, only: [:create] do
      post "/login", to: "users#login"
      get "/auto_login", to: "users#auto_login"
      get "/get_rides", to: "rides#get_rides"
    end

    resource :rides do
      get "/get_rides", to: "rides#get_rides"
    end

    resource :drivers do
      get "/get_available_drivers", to: "drivers#get_available_drivers"
    end
  end
end
