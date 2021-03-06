# frozen_string_literal: true

require 'test_helper'

class UsersEndpointTest < ActionDispatch::IntegrationTest
  def endpoint
    '/users'
  end

  def test_it_requires_athentication
    get endpoint

    assert_equal '401', response.code
  end

  def test_without_params_it_returns_all_records
    log_in_as(users(:first))

    get endpoint, params: {}, headers: valid_headers

    assert_equal '200', response.code

    refute(response.body == '[]' || response.body.blank?)
    assert_equal User.all.to_json, response.body
  end

  def test_with_params_it_returns_selected_records
    skip
  end

  def test_profile_endpoint_returns_current_user_show
    log_in_as(users(:second))

    get '/profile', params: {}, headers: valid_headers

    assert_equal '200', response.code

    refute(response.body == '[]' || response.body.blank?)
    assert_equal users(:second).to_json, response.body
  end
end
