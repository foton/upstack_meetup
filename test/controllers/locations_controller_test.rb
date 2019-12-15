require 'test_helper'

class LocationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @location = locations(:first_loc)
    log_in_as(users(:first))
  end

  test "should get index" do
    get locations_url, as: :json, headers: valid_headers
    assert_response :success
  end

  test "should create location" do
    assert_difference('Location.count') do
      post locations_url,
           params: { location: { city: @location.city, country: @location.country, lat: @location.lat, lng: @location.lng, postal_code: @location.postal_code, status: @location.status, surfable: @location.surfable, user_uid: @location.user_uid } },
           as: :json,
           headers: valid_headers
    end

    assert_response 201
  end

  test "should show location" do
    get location_url(@location), as: :json, headers: valid_headers
    assert_response :success
  end

  test "should update location" do
    patch location_url(@location),
          params: { location: { city: @location.city, country: @location.country, lat: @location.lat, lng: @location.lng, postal_code: @location.postal_code, status: @location.status, surfable: @location.surfable, user_uid: @location.user_uid } },
          as: :json,
          headers: valid_headers
    assert_response 200
  end

  test "should destroy location" do
    assert_difference('Location.count', -1) do
      delete location_url(@location), as: :json, headers: valid_headers
    end

    assert_response 204
  end
end
