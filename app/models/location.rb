class Location < ApplicationRecord
  belongs_to :user, class_name: 'User', foreign_key: :user_uid, primary_key: :uid
end
