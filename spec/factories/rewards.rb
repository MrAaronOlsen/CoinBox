FactoryGirl.define do

  factory :reward do
    name 'Rock'
    desc "It's Friendly!"

    trait :with_users do

      transient { user_count 3 }

      after(:create) do |reward, evaluator|
        reward.users << create_list(:user, evaluator.user_count)
      end
    end
  end

end