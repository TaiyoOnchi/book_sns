class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments
  has_many :favorites
  acts_as_taggable_on :tags
    
  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }
  
  # タグでの検索用スコープ
  scope :with_tag_name, ->(tag_name) {
    joins(:tags).where('tags.name LIKE ?', "%#{tag_name}%")
  }

  # Ransackで使用可能な属性を指定
  def self.ransackable_attributes(auth_object = nil)
    ["title", "body", "rating"]
  end

  # Ransackで使用可能な関連付けを指定
  def self.ransackable_associations(auth_object = nil)
    ["user", "tags"]
  end

  # Ransackで使用可能なスコープを指定
  def self.ransackable_scopes(auth_object = nil)
    [:with_tag_name]
  end
  
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
end
