require "test_helper"

class JwtAuthenticationTest < ActionDispatch::IntegrationTest
  attr_reader :user

  def setup
    @user = User.create!(email: 'mini@me.com',
                        password: 'Abcd1234')

    @existing_user_params = { email: user.email, password: 'Abcd1234' }
  end

  def test_successfull_login
    login_params = { user: @existing_user_params }

    post '/login', params: login_params

    assert_equal '200', response.code
    assert response.headers['Authorization'].present?

    token_from_request = response.headers['Authorization'].split(' ').last
    decoded_token = JWT.decode(token_from_request, ENV['DEVISE_JWT_SECRET_KEY'], true)
    assert decoded_token.first['sub'].present?
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
    params = { email: 'my@email.com' , password: 'fdsfsfsd'}
    post '/register', params: params

    assert_equal '200', response.code
    expect(JSON.parse(response.body)[:email]).to eq(params[:email])
  end

  def registration_of_with_existing_email
    params = { email: @existing_user_params[:email] , password: 'fdsfsfsd'}

    post '/register', params: params

    assert_equal '400', response.code
    expect(JSON.parse(response.body)['errors'].first['title']).to eq('Bad Request')
  end

  # def valid_headers
  #   { 'CONTENT_TYPE' => 'application/json' }
  #     #'Authorization' => "Token token=\"#{@api_token.token}\"" }
  # end
end
