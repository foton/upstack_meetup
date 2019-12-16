# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def log_in_as(user)
    post '/login', params: { user: { email: user.email, password: user.clear_password } }

    assert_equal '200', response.code
    assert response.headers['Authorization'].present?

    @jwt_token = response.headers['Authorization'].split(' ').last
  end

  def valid_headers
    { 'CONTENT_TYPE' => 'application/json',
      'Authorization' => "Bearer #{@jwt_token}" }
  end
end
