class UserKeyword < ApplicationRecord
  belongs_to :keyword
  belongs_to :user
end
