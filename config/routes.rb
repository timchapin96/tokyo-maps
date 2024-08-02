Rails.application.routes.draw do
  root "wards#index"
  #custom sort route

  get 'sort/:sortVal' => 'wards#sort', constraints: {sortVal: /(one_ldk_sort_color|two_ldk_sort_color|three_ldk_sort_color|safety_sort_color|pet_sort_color|international_schools_sort_color)/}

  #API routes
  #
end
