class WardsController < ApplicationController
  def index
    @wards = Ward.all
    p @wards
  end
  def sort
    sort_param = sort_params[:sortVal]

    valid_sort_vals = ["one_ldk_sort_color", "two_ldk_sort_color", "three_ldk_sort_color", "safety_sort_color", "pet_sort_color", "international_schools_sort_color"]
    if valid_sort_vals.include?(sort_param)
      respond_to do |format|
        format.json { render json: { message: "JSON rendered #{sort_param}" } } # handle JSON request
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  private

  def sort_params
    params.permit(:sortVal)
  end
end
