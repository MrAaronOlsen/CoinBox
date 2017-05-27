FactoryGirl.define do

  factory :coin do
    denom 0

    trait :with_user do

      after(:create) do |coin|
        coin.user = create(:user)
      end
    end

    trait :with_reward do

      after(:create) do |coin|
        coin.user_reward = create(:user, :with_rewards).user_rewards.last
      end
    end
  end

end