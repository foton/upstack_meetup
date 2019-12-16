# frozen_string_literal: true

class Location < ApplicationRecord
  CLOSE_LIMIT = 0.2 # thi makes distance about 20km around Olomouc :-)

  belongs_to :user, class_name: 'User', foreign_key: :user_uid, primary_key: :uid
end
