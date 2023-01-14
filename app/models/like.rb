class Like < ApplicationRecord
  belongs_to :like_user, class_name: "User"
  belongs_to :liked_user, class_name: "User"
  validates :like_user_id, {presence: true}
  validates :liked_user_id, {presence: true}
end
