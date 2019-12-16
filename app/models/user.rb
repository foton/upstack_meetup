class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JwtBlacklist

  has_one :location, foreign_key: :user_uid, primary_key: :uid
  has_many :sent_messages, class_name: 'Message', foreign_key: :from_uid, primary_key: :uid
  has_many :received_messages, class_name: 'Message', foreign_key: :to_uid, primary_key: :uid
  has_many :invites, class_name: 'Invite', foreign_key: :from_uid, primary_key: :uid

  before_validation :generate_uid,  if: Proc.new { |user| user.uid.blank? }
  validates :uid, presence: true, uniqueness: true
  validate :at_least_one_name

  def generate_uid
    self.uid = SecureRandom.uuid
  end

  def to_param
    uid
  end

  def at_least_one_name
    return if (first_name.to_s + last_name.to_s).present?

    errors.add(:first_name, 'At least one name must be present')
    errors.add(:last_name, 'At least one name must be present')
  end
end
