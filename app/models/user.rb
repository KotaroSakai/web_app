require 'bcrypt'

class User < ApplicationRecord
  enum role: { smoker: 0, partner: 1}
  has_many :posts, dependent: :destroy
  has_many :smoke_records, dependent: :destroy
  has_one :tobacco, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_one :send_set, dependent: :destroy

  has_many :follows, class_name: "UserPartner", foreign_key: :followed_id # コードを入力してもらうユーザー
  has_many :followers, class_name: "UserPartner", foreign_key: :follower_id # コードを入力したユーザー


  before_save :update_invitation_token

  after_create :create_send_set

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[line]

  def social_profile(provider)
    social_profiles.select { |sp| sp.provider == provider.to_s }.first
  end

  def set_values(omniauth)
    return if provider.to_s != omniauth["provider"].to_s || uid != omniauth["uid"]
    credentials = omniauth["credentials"]
    info = omniauth["info"]

    access_token = credentials["refresh_token"]
    access_secret = credentials["secret"]
    credentials = credentials.to_json
    name = info["name"]
    # self.set_values_by_raw_info(omniauth['extra']['raw_info'])
  end

  def set_values_by_raw_info(raw_info)
    self.raw_info = raw_info.to_json
    self.save!
  end

  def self.find_by_token(input_token)
    find_by(token: input_token)
  end

  def following?(other_user)
    follows.find_by(followed_id: other_user.id).present?
  end

  def follower?(other_user)
    followers.find_by(follower_id: other_user.id).present?
  end

  private

  def update_invitation_token
    self.token = generate_unique_token
  end

  def generate_unique_token
    SecureRandom.uuid
  end

  def create_send_set #通知時間作成
    send_set = build_send_set(
      send_active: false,
      set_time: Time.current.change(hour: 9, min: 0, sec: 0)
    )
    send_set.save
  end
  
end
