class Reward < ApplicationRecord
  validates :name, :desc, presence: true
end
