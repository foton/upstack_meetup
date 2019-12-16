require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @message = messages(:m12_1)
    log_in_as(users(:first))
  end

  test "should get index" do
    get messages_url, as: :json, headers: valid_headers
    assert_response :success
  end

  test "should get messages sent by user" do
    get messages_url(params: { from_uid: users(:first).uid }),
        as: :json,
        headers: valid_headers

    assert_response :success

    returned_messages = JSON.parse(response.body)
    expected_messages = users(:first).sent_messages.order(created_at: :desc, id: :desc)
    assert_equal expected_messages.size, returned_messages.size
    assert_equal expected_messages.to_json, response.body
  end

  test "should get messages received by user" do
    get messages_url(params: { to_uid: users(:first).uid }),
        as: :json,
        headers: valid_headers

    assert_response :success

    returned_messages = JSON.parse(response.body)
    expected_messages = users(:first).received_messages.order(created_at: :desc, id: :desc)
    assert_equal expected_messages.size, returned_messages.size
    assert_equal expected_messages.to_json, response.body
  end

  test "should get chat between users" do
    # /messages?chat_between%5B%5D=first-user&chat_between%5B%5D=third-user"
    get messages_url(params: { chat_between: [users(:first).uid, users(:third).uid] }),
        as: :json,
        headers: valid_headers

    assert_response :success

    returned_messages = JSON.parse(response.body)
    expected_messages = (users(:first).sent_messages & users(:third).received_messages)
    expected_messages += (users(:first).received_messages & users(:third).sent_messages)

    assert_equal expected_messages.size, returned_messages.size
    assert_equal expected_messages.sort.reverse.to_json, response.body
  end


  test "should get messages received by user nad not read yet" do
    get messages_url(params: { to_uid: users(:first).uid, is_read: 0 }),
        as: :json,
        headers: valid_headers

    assert_response :success

    returned_messages = JSON.parse(response.body)
    expected_messages = users(:first).received_messages.where(is_read: 0).order(created_at: :desc, id: :desc)
    assert_equal expected_messages.size, returned_messages.size
    assert_equal expected_messages.to_json, response.body
  end

  test "should create message" do
    assert_difference('Message.count') do
      post messages_url,
          params: { message: { body: @message.body, from_uid: @message.from_uid, is_read: @message.is_read, to_uid: @message.to_uid } },
          as: :json,
          headers: valid_headers
    end

    assert_response 201
  end

  test "should show message" do
    get message_url(@message), as: :json, headers: valid_headers
    assert_response :success
  end

  test "should update message" do
    patch message_url(@message),
          params: { message: { body: @message.body, from_uid: @message.from_uid, is_read: @message.is_read, to_uid: @message.to_uid } },
          as: :json,
          headers: valid_headers
    assert_response 200
  end

  test "should destroy message" do
    assert_difference('Message.count', -1) do
      delete message_url(@message), as: :json, headers: valid_headers
    end

    assert_response 204
  end
end
