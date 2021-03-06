# frozen_string_literal: true

require 'test_helper'

class UsersEndpointTest < ActionDispatch::IntegrationTest
  def endpoint
    '/invites'
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
    assert_equal Invite.all.to_json, response.body
  end

  def test_with_params_it_returns_selected_records
    skip
  end
end
