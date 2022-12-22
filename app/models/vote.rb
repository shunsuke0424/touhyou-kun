class Vote < ApplicationRecord
  belongs_to :voter, class_name: "User"
  belongs_to :voted, class_name: "User"
  belongs_to :keyword

  validates :voter_id, presence: true
  validates :voted_id, presence: true
  validates :keyword_id, presence: true
end
