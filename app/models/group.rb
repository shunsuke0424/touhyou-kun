class Group < ApplicationRecord
  has_many :member_ships, dependent: :destroy
  has_many :users, through: :member_ships, dependent: :destroy
  validates :name, presence: { message: 'は必須項目です' }
end
