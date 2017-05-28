FactoryGirl.define do

  factory :user do

    sequence :username do |i|
      "FuzzyLumpkin#{i}"
    end
    password "password"
    profile
  end

  trait :with_rewards do
    transient { reward_count 1 }

    after(:create) do |user, evaluator|
      user.rewards << create_list(:reward, evaluator.reward_count)
    end
  end

  trait :with_coins do
    after(:create) do |user|
      user.coins << create_list(:coin, 30, denom: 0)
      user.coins << create_list(:coin, 20, denom: 1)
      user.coins << create_list(:coin, 15, denom: 2)
      user.coins << create_list(:coin, 10, denom: 3)
    end
  end

  trait :with_all do
    after(:create) do |user|
      user.rewards << create(:reward, name: 'Rock', desc: "It's friendly!", cost: 7)
      user.rewards << create(:reward, name: 'Icecream', desc: "It's cold!", cost: 15)
      user.coins << create_list(:coin, 30, denom: 0)
      user.coins << create_list(:coin, 20, denom: 1)
      user.coins << create_list(:coin, 15, denom: 2)
      user.coins << create_list(:coin, 10, denom: 3)
    end
  end

  trait :as_admin do
    after(:create) do |user|
      user.admin!
    end
  end

end
