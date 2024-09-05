class Group < ApplicationRecord
  has_many :group_users, dependent: :destroy
  has_one_attached :group_image
  has_many :users, through: :group_users
  has_many :events,dependent: :destroy
  
  validates :name,presence: true
  validates :introduction, length: { maximum: 50 }
  validates :owner_id,presence: true
  
   def get_group_image(weight, height)
    unless self.group_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      group_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    self.group_image.variant(resize_to_fill: [weight,height]).processed
  end
  
  def joined_by?(user) 
    group_users.exists?(user_id: user.id)
  end
end
