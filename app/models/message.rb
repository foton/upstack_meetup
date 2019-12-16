class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User', foreign_key: :from_uid, primary_key: :uid
  belongs_to :receiver, class_name: 'User', foreign_key: :to_uid, primary_key: :uid

  validates_presence_of :body

  def <=>(other)
    ct = (self.created_at <=> other.created_at)
    ct.zero? ? (self.id <=> other.id) : ct
  end
end
