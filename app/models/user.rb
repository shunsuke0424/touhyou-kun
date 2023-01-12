class User < ApplicationRecord
  has_secure_password
  has_many :user_keywords, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :member_ships, dependent: :destroy
  has_many :groups, through: :member_ships, dependent: :destroy
  # has_many :likes, dependent: :destroy
  has_many :like_user_relationships, foreign_key: :like_user_id, class_name: 'Like'
  has_many :likes, through: :like_user_relationships, source: :like_user
  validates :name, presence: { message: 'は必須項目です' }

end
