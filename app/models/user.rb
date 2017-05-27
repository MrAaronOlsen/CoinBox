class User < ApplicationRecord
  has_secure_password

  has_many :coins
  has_many :user_rewards
  has_many :rewards, through: :user_rewards
  has_one :profile

  validates_associated :profile
  validates :username, presence: true
  validates_uniqueness_of :username, case_sensitive: false
  validates_length_of :password, minimum: 7
  validates :role, presence: true

  enum role: ['user', 'admin']

  def afford?(reward)
    reward.cost <= money_in_box.sum(&:value)
  end

  def money_in_box
    coins.where(user_reward_id: nil)
  end

  def show_coins
    all_coins = money_in_box

    [ all_coins.where(denom: 3),
      all_coins.where(denom: 2),
      all_coins.where(denom: 1),
      all_coins.where(denom: 0) ]
   end

  def claim(reward)
    if afford?(reward)
      buy(reward)
    else
      false
    end
  end

  def buy(reward)
    values = [15, 8, 3, 1]
    purchased = false

    until purchased

      coins_in_hand = []
      usable_coins = show_coins
      denomination = 0

      until denomination > 3
        coin_num = 0

        until reward.cost - count(coins_in_hand) < values[denomination]
          break if usable_coins[denomination].count == coin_num
          coins_in_hand << usable_coins[denomination][coin_num]
          coin_num+=1
        end

        purchased = true if count(coins_in_hand) == reward.cost
        denomination+=1
        make_change if denomination == show_coins.count
      end

    end

    rewards << reward
    user_reward = user_rewards.last
    user_reward.coins << coins_in_hand
    user_reward
  end

  def count(coins_in_hand)
    coins_in_hand.reduce(0) { |memo, coin| memo + coin.value }
  end

  def make_change
    coins_in_hand = show_coins.reverse
    denomination = 1
    until denomination > 3
      coin = coins_in_hand[denomination].first
      unless coin.nil?
        coin.value.times { coins << Coin.create(denom: 0) }
        coin.destroy
        break
      end
      denomination+=1
    end
  end

end
