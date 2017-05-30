class UserReward < ApplicationRecord
  has_many :coins
  belongs_to :user
  belongs_to :reward
end
