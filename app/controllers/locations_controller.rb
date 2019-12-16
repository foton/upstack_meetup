class LocationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_location, only: [:show, :update, :destroy]

  # GET /locations
  def index
    @locations = restrict_resources_by_params(Location.all)

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

  def restrict_resources_by_params(resources)
    resources = super(resources)

    if params[:lat].present? && params[:lng].present?
      lat_range, lng_range = bounding_close_ranges(lat: params[:lat].to_f, lng: params[:lng].to_f)
      resources = resources.where(lng: lng_range, lat: lat_range)
    end

    resources = resources.where(user_uid: params[:user_uid].strip) if params[:user_uid].present?

    resources
  end

  def bounding_close_ranges(lat:, lng:)
    # lat = - 90 .. 90 (North pole)
    # long = -180 .. 180 (0 is Greenwich; + going west)
    lat_range = (lat - Location::CLOSE_LIMIT)..(lat + Location::CLOSE_LIMIT)
    lng_range = (lng - Location::CLOSE_LIMIT)..(lng + Location::CLOSE_LIMIT)
    [lat_range, lng_range]
  end
end
