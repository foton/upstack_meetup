# frozen_string_literal: true

require 'test_helper'

class JwtAuthenticationTest < ActionDispatch::IntegrationTest
  attr_reader :user

  def setup
    @user = User.create!(email: 'mini@me.com',
                         password: 'Abcd1234')

    @existing_user_params = { email: user.email, password: 'Abcd1234' }
  end

  def test_login_endpoint_with_get
    get '/login'

    assert_equal '200', response.code

    john_doe_json = '{"user":{"id":null,"uid":"","first_name":"John","last_name":"Doe","email":"",' \
                    '"password":null,"clear_password":"","avatar":"","status":0,' \
                    '"created_at":null,"updated_at":null},"token":null}'
    assert_equal john_doe_json, response.body
  end

  def test_successfull_login
    login_params = { user: @existing_user_params }

    post '/login', params: login_params

    assert_equal '200', response.code
    assert response.headers['Authorization'].present?

    json = JSON.parse(response.body)
    assert_equal @existing_user_params[:email], json['user']['email']

    token_from_request = response.headers['Authorization'].split(' ').last
    assert_equal token_from_request, json['token']

    decoded_token = JWT.decode(token_from_request, ENV['DEVISE_JWT_SECRET_KEY'], true)
    assert decoded_token.first['sub'].present?
    assert_equal 'user', decoded_token.first['scp']
  end

  def test_failed_login
    login_params = { user: { email: user.email, password: 'Abcd' } }

    post '/login', params: login_params.to_json

    assert_equal '401', response.code
  end

  def test_logout
    delete '/logout'

    assert_equal '204', response.code
  end

  def registration_of_not_existing_user
    params = { email: 'my@email.com', password: 'fdsfsfsd' }
    post '/register', params: params

    assert_equal '200', response.code
    assert_equal params[:email], JSON.parse(response.body)[:email]
  end

  def registration_of_with_existing_email
    params = { email: @existing_user_params[:email], password: 'fdsfsfsd' }

    post '/register', params: params

    assert_equal '400', response.code
    assert_equal 'Bad Request', JSON.parse(response.body)['errors'].first['title']
  end
end
