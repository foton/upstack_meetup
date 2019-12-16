# frozen_string_literal: true

require 'test_helper'

class UserRoamingTest < ActionDispatch::IntegrationTest
  attr_reader :user, :params, :token

  def setup
    @params = { first_name: 'Test', last_name: 'Testovič', email: 'my@email.com', password: 'Abcd1234', avatar: 'some_url' }
    @jwt_token = nil
    @user = nil
  end

  def test_can_register_and_login
    params = { email: 'my@email.com', password: 'fdsfsfsd' }

    register
    login
    get_profile
    update_user

    create_location
    find_locations_for_user
  end

  def register
    # wrong call
    post '/register', params: { user: { x: 1 } }, as: :json
    assert_equal '400', response.code

    json = json_response
    assert json['errors'].present?

    # correct call
    assert_difference('User.count') do
      post '/register', params: { user: params }, as: :json
    end
    assert_equal '200', response.code

    json = json_response
    assert_equal params[:email], json['email']
    @user = User.last
  end

  def login
    # wrong calls
    post '/login', params: { user: { email: params[:email] + 'x', password: params[:password] } }, as: :json
    assert_equal '401', response.code
    json = json_response
    assert_equal 'Invalid Email or password.', json_response['error']

    post '/login', params: { user: { email: params[:email], password: params[:password] + 'x' } }, as: :json
    assert_equal '401', response.code
    json = json_response
    assert_equal 'Invalid Email or password.', json_response['error']

    # correct_one
    post '/login', params: { user: { email: params[:email], password: params[:password] } }, as: :json

    assert_equal '200', response.code
    assert response.headers['Authorization'].present?

    json = json_response
    assert_equal params[:email], json['user']['email']
    @jwt_token = json['token']
  end

  def get_profile
    get '/profile', params: {}, headers: valid_headers

    json = json_response
    assert_equal '200', response.code
    params.each_pair do |atrb, value|
      next if atrb == :password

      # no 'user' scope!
      assert_equal value, json[atrb.to_s], "Wrong value for :#{atrb}! expected #{value}, got #{json[atrb.to_s]}"
    end
  end

  def update_user
    put "/users/#{user.uid}", # TODO: PUT '/profile'
        params: { user: { last_name: 'TTT' } },
        as: :json,
        headers: valid_headers

    json = json_response
    assert_equal '200', response.code
    assert_equal 'TTT', json['last_name']
    assert_equal 'TTT', user.reload.last_name
  end

  def create_location
    post '/locations',
         params: { location: { user_uid: user.uid,
                               city: 'Ankara',
                               country: 'Republic of Turkey',
                               postal_code: 78_372,
                               lat: 40.00,
                               lng: 33.00,
                               status: 1,
                               surfable: false } },
         as: :json,
         headers: valid_headers

    json = json_response
    assert_equal '201', response.code
    assert_equal 'Ankara', json['city']
  end

  def find_locations_for_user
    get '/locations', params: { user_uid: user.uid }, headers: valid_headers

    json = json_response
    assert_equal '200', response.code
    assert_equal 1, json.size
    assert_equal 'Ankara', json.first['city']
  end

  def json_response
    # puts("Responsebody: #{response.body}")
    JSON.parse(response.body)
  end
end
