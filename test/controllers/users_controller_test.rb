require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:first)
    log_in_as(users(:first))
  end

  test "should get index" do
    get users_url, as: :json, headers: valid_headers
    assert_response :success

    returned_users = JSON.parse(response.body)
    assert_equal User.count, returned_users.size
  end

  test "should get index with limit and offset" do
    get users_url(params: { offset: 1, limit: 1 }),
                  as: :json,
                  headers: valid_headers
    assert_response :success

    returned_users = JSON.parse(response.body)
    expected_users = User.limit(1).offset(1)
    assert_equal 1, returned_users.size
    assert_equal expected_users.to_json, response.body
  end


  test "should get users by_user uid" do
    get users_url(params: { uid: users(:first).uid }),
        as: :json,
        headers: valid_headers

    assert_response :success
    returned_users = JSON.parse(response.body)

    assert_equal 1, returned_users.size
    assert_equal [users(:first)].to_json, response.body
  end


  test "should create user" do
    assert_difference('User.count') do
      post users_url,
           params: { user: { avatar: @user.avatar,
                             email: 'new@user.com',
                             first_name: @user.first_name,
                             last_name: @user.last_name,
                             password: 'some_password',
                             status: @user.status } },
           as: :json,
           headers: valid_headers
    end

    assert_response 201
  end

  test "should show user" do
    get user_url(@user), as: :json, headers: valid_headers
    assert_response :success
  end

  test "should update user" do
    patch user_url(@user),
          params: { user: { avatar: @user.avatar, email: @user.email, first_name: @user.first_name, last_name: @user.last_name, status: @user.status } },
          as: :json,
          headers: valid_headers

    assert_response 200
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete user_url(@user), as: :json, headers: valid_headers
    end

    assert_response 204
  end
end
