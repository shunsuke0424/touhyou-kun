class User < ApplicationRecord
  has_secure_password
  has_many :user_keywords, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :member_ships, dependent: :destroy
  has_many :groups, through: :member_ships, dependent: :destroy

  validates :name, presence: { message: 'は必須項目です' }

end
