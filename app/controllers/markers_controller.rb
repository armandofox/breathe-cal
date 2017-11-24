class MarkersController < ApplicationController
  # Added this to prevent 'Can't verify CSRF token authenticity' heroku error
  skip_before_action :verify_authenticity_token
  
  # Create a new marker
  def create
    marker = Marker.create!(marker_params.merge(:user_id => current_or_guest_user.id))
    render :json => marker
  end

  # Show all markers inside the bounds of the map
  def show
    up = bound_params[:uplat]
    down = bound_params[:downlat]
    left = bound_params[:leftlong]
    right = bound_params[:rightlong]
    markers = Marker.find_all_within_bounds(up, down, left, right)
    render :json => markers
  end
  
  # Remove a marker
  def destroy
    @patient = Marker.find(params[:id])
    @patient.destroy
  end
  
  private
  
  def marker_params
    params.require(:marker).permit(:cat, :dog, :mold, :bees, :perfume, :oak, :peanut, :gluten, :dust, :smoke, :title, :user_id)
  end

  def bound_params
    params.require(:bounds).permit(:uplat, :downlat, :rightlong, :leftlong)
  end
end
