Rails.application.routes.draw do
  root "wards#index"
  #custom sort route
  get 'sort/:sortVal' => 'wards#sort'

  #API routes
  #
  namespace :api do
    namespace :v1 do
      get 'maps/api_key'
    end
  end
end
