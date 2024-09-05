class Chat < ApplicationRecord
  belongs_to :relationship
  has_one    :user,  through: :relationship
end
