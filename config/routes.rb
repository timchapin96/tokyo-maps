Rails.application.routes.draw do
  root "wards#index"
  #custom sort route
  get 'sort/:sortVal' => 'wards#sort'

  #API routes
  #
end
