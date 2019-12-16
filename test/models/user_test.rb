# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  attr_reader :user

  def setup
    @user = users(:first)
  end

  def test_can_have_location
    location = user.location
    assert location.present?
  end

  def test_can_have_invites
    assert_equal 2, user.invites.count
  end

  def test_can_have_sended_messages
    assert_equal 4, user.sent_messages.count
  end

  def test_can_have_received_messages
    assert_equal 3, user.received_messages.count
  end

  def test_should_validate_email
    skip
  end

  def test_should_validate_both_names
    u = User.new(valid_params)
    assert u.valid?

    u = User.new(valid_params.merge(last_name: ''))
    assert u.valid? # still have first name

    u = User.new(valid_params.merge(first_name: ''))
    assert u.valid?

    u = User.new(valid_params.merge(last_name: '', first_name: ''))
    refute u.valid?
    assert u.errors[:first_name].present?
    assert u.errors[:last_name].present?
  end

  def test_should_generate_uid_on_creation_if_there_is_not
    u = User.new(valid_params)
    assert u.valid?
    assert u.uid.present?

    uid = 'sdasdasdasd-daasd-ad'
    u = User.new(valid_params.merge(uid: uid))
    assert u.valid?
    assert u.uid.present?
    assert_equal uid, u.uid
  end

  def test_should_validate_uniquenes_of_uid
    u = User.new(valid_params.merge(uid: user.uid))
    refute u.valid?
    assert u.errors[:uid].present?
  end

  def valid_params
    { first_name: 'Ferdinand',
      last_name: 'Trevory',
      email: 'trevory@company.com',
      password: 'Abcd1234',
      avatar: 'http://url.to.nowhere.com' }
  end
end
