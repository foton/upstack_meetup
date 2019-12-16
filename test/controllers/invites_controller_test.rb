# frozen_string_literal: true

require 'test_helper'

class InvitesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @invite = invites(:first2mickey)
    log_in_as(users(:first))
  end

  test 'should get index' do
    get invites_url, as: :json, headers: valid_headers
    assert_response :success

    returned_invites = JSON.parse(response.body)
    assert_equal Invite.count, returned_invites.size
  end

  test 'should get invites from user by from_uid' do
    get invites_url(params: { from_uid: users(:first).uid }),
        as: :json,
        headers: valid_headers

    assert_response :success

    returned_invites = JSON.parse(response.body)
    assert_equal users(:first).invites.size, returned_invites.size
    assert_equal users(:first).invites.to_json, response.body
  end

  test 'should create invite' do
    assert_difference('Invite.count') do
      post invites_url,
           params: { invite: { from_uid: @invite.from_uid, to_address: @invite.to_address } },
           as: :json,
           headers: valid_headers
    end

    assert_response 201
  end

  test 'should show invite' do
    get invite_url(@invite), as: :json, headers: valid_headers
    assert_response :success
  end

  test 'should update invite' do
    patch invite_url(@invite),
          params: { invite: { from_uid: @invite.from_uid, to_address: @invite.to_address } },
          as: :json,
          headers: valid_headers
    assert_response 200
  end

  test 'should destroy invite' do
    assert_difference('Invite.count', -1) do
      delete invite_url(@invite), as: :json, headers: valid_headers
    end

    assert_response 204
  end
end
