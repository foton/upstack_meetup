require 'test_helper'

class LocationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @location = locations(:first_loc)
    log_in_as(users(:first))
  end

  test "should get index" do
    get locations_url, as: :json, headers: valid_headers

    assert_response :success

    locations = JSON.parse(response.body)
    assert_equal Location.count, locations.size
  end

  test "should get index with lng and lat restriction" do
    Location.delete_all
    close_locations = create_related_locations_to(@location, :close, 2)
    distant_locations = create_related_locations_to(@location, :distant, 3)

    get locations_url(params: { lat: @location.lat, lng: @location.lng }),
        as: :json,
        headers: valid_headers

    assert_response :success
    returned_locations = JSON.parse(response.body)

    assert_equal close_locations.size, returned_locations.size
    assert_equal close_locations.to_json, response.body
  end

  test "should get locations by user uid" do
    get locations_url(params: { user_uid: users(:first).uid }),
        as: :json,
        headers: valid_headers

    assert_response :success
    returned_locations = JSON.parse(response.body)

    assert_equal 1, returned_locations.size
    assert_equal [users(:first).location].to_json, response.body
  end

  test "should create location" do
    assert_difference('Location.count') do
      post locations_url,
           params: { location: { city: @location.city,
                                 country: @location.country,
                                 lat: @location.lat,
                                 lng: @location.lng,
                                 postal_code: @location.postal_code,
                                 status: @location.status,
                                 surfable: @location.surfable,
                                 user_uid: @location.user_uid } },
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

  def create_related_locations_to(location, proximity, count)
    count.times.collect do |i|
      lng = location.lng + random_diff(proximity)
      lat = location.lat + random_diff(proximity)
      Location.create!(lng: lng, lat: lat, city: "Point#{i}", user_uid: users(:third).uid)
    end
  end

  def random_diff(proximity)
    if proximity == :close
      rand((-1 * Location::CLOSE_LIMIT)..Location::CLOSE_LIMIT)
    else
      signs = [-1, 1]
      rand((Location::CLOSE_LIMIT + 0.01)..(5 * Location::CLOSE_LIMIT)) * signs[(rand(0..1))]
    end
  end
end
