class Relationship < ApplicationRecord
  #belongs_to :user 要らない
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  has_many :chats
end
