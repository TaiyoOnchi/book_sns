class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  # あるユーザー(自分)をフォローしている人(フォロワー)の一覧を取得するアソシエーション
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy#follower→followed
  has_many :followers, through: :reverse_of_relationships, source: :follower #throughのrがない

  # あるユーザー(自分)がフォローしている人(フォロイー)の一覧を取得するアソシエーション
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy#followed→follower
  has_many :followings, through: :relationships, source: :followed
  
  has_many :chats, through: :relationships
  has_many :group_users, dependent: :destroy
  has_many :groups, through: :group_users
  

  has_one_attached :profile_image
  
  include JpPrefecture
  jp_prefecture :prefecture_code
  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end
  
  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end
  
  def join_address
    "#{self.prefecture_name}#{self.address_city}#{self.address_street}#{self.address_building}"
  end
  
  geocoded_by :address_city
  after_validation :geocode, if: :address_city_changed? #市区町村から緯度経度を

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }

  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end

  def follow(user)
    relationships.create!(followed_id: user.id)
  end

  # find→find_by
  def unfollow(user)
    relationships.find_by(followed_id: user.id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

  def get_profile_image(weight, height)
    unless self.profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    self.profile_image.variant(resize_to_fill: [weight,height]).processed
  end
end
