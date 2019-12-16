# frozen_string_literal: true

class Invite < ApplicationRecord
  belongs_to :user, class_name: 'User', foreign_key: :from_uid, primary_key: :uid
end
