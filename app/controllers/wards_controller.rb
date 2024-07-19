class WardsController < ApplicationController
  def index
    @wards = Ward.all
  end
  def sort
    sort_param = sort_params[:sortVal]

    respond_to do |format|
      format.json { render json: { message: "JSON rendered #{sort_param}" } } # handle JSON request
    end
  end

  private

  def sort_params
    params.permit(:sortVal)
  end
end
