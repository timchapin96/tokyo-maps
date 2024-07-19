class Api::V1::MapsController < ApplicationController
  before_action :authenticate_user!, except: [:api_key]

  def api_key
    render json: { api_key: ENV['MAPBOX_API_KEY'] }
  end
end
