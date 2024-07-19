Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'maps/api_key'
    end
  end

  #TODO - write route to serve the API key instead of passing through stimulus
  root "wards#index"
  #custom sort route
  get 'sort/:sortVal' => 'wards#sort'

  get 'map/api_key', to: 'map#api_key'
end
