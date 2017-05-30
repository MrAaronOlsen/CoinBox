class Coin < ApplicationRecord
  belongs_to :user_reward, optional: true
  belongs_to :user, optional: true

  validates :denom, presence: true
  validates :denom, numericality: { less_than: 4,
                                     greater_than_or_equal_to: 0 }

  def name
    ['Copper', 'Silver', 'Gold', 'Ruby'][denom]
  end

  def value
    [1, 3, 8, 15][denom]
  end

  def redeemed?
    user_reward_id != nil
  end

end
