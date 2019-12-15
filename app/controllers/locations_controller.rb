class LocationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_location, only: [:show, :update, :destroy]

  # GET /locations
  def index
    @locations = Location.all

    if params[:lat].present? && params[:lng].present?
      @locations = select_close_locations(lat: params[:lat].to_f, lng: params[:lng].to_f)
    end

    render json: @locations
  end

  # GET /locations/1
  def show
    render json: @location
  end

  # POST /locations
  def create
    @location = Location.new(location_params)

    if @location.save
      render json: @location, status: :created, location: @location
    else
      render json: @location.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /locations/1
  def update
    if @location.update(location_params)
      render json: @location
    else
      render json: @location.errors, status: :unprocessable_entity
    end
  end

  # DELETE /locations/1
  def destroy
    @location.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_location
    @location = Location.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def location_params
    params.require(:location).permit(:user_uid, :city, :country, :postal_code, :lat, :lng, :status, :surfable)
  end

  def select_close_locations(lat:, lng:)
    lat_range = (lat - Location::CLOSE_LIMIT)..(lat + Location::CLOSE_LIMIT)
    lng_range = (lng - Location::CLOSE_LIMIT)..(lng + Location::CLOSE_LIMIT)
    @locations.where(lng: lng_range, lat: lat_range)
  end
end
