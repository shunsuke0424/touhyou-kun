class Like < ApplicationRecord
  validates :like_user_id, {presence: true}
  validates :liked_user_id, {presence: true}
end
