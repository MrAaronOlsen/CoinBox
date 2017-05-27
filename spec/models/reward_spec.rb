require 'rails_helper'

RSpec.describe Reward do

  describe "Validations" do

    it { should have_many(:users).through(:user_rewards) }

    it "is valid" do
      expect(build(:reward)).to be_valid
    end

    it "does not have a name" do
      reward = build(:reward, name: "")

      expect(reward).to  be_invalid
    end

    it "does not have a description" do
      reward = build(:reward, desc: "")

      expect(reward).to  be_invalid
    end

    it "has a default cost of 0" do
      reward = create(:reward)

      expect(reward.cost).to eq(0)
    end
  end

  describe "Associations" do

    it "has many users" do
      reward = create(:reward, :with_users, user_count: 3)

      expect(reward.users.count).to eq(3)
    end
  end
end