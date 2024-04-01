class WardsController < ApplicationController
  def index
    @wards = Ward.all
  end
end
