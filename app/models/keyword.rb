class Keyword < ApplicationRecord
  has_many :user_keywords
  has_many :votes
end
