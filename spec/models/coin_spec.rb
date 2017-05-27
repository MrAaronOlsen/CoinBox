require 'rails_helper'

RSpec.describe Coin do

  describe 'Validations' do

    it { should belong_to(:user) }
    it { should belong_to(:user_reward) }
    it { should validate_numericality_of(:denom).is_less_than(4) }
    it { should validate_numericality_of(:denom).is_greater_than_or_equal_to(0) }

    it 'is valid' do
      expect(build(:coin)).to be_valid
    end

    it 'does not supply a denom' do
      coin = build(:coin, denom: "")
      expect(coin).to be_invalid
      expect(coin.errors.full_messages).to eq(["Denom can't be blank", "Denom is not a number"])
    end

    it 'supplies denom is out of range' do
      coin = build(:coin, denom: 4)
      expect(coin).to be_invalid
      expect(coin.errors.full_messages).to eq(["Denom must be less than 4"])
      coin = build(:coin, denom: -1)
      expect(coin).to be_invalid
      expect(coin.errors.full_messages).to eq(["Denom must be greater than or equal to 0"])
    end
  end

  describe 'Point denoms and value enums' do

    it 'is copper' do
      coin = create(:coin, denom: 0)

      expect(coin.name).to eq('Copper')
      expect(coin.value).to eq(1)
    end

    it 'is silver' do
      coin = create(:coin, denom: 1)

      expect(coin.name).to eq('Silver')
      expect(coin.value).to eq(3)
    end

    it 'is gold' do
      coin = create(:coin, denom: 2)

      expect(coin.name).to eq('Gold')
      expect(coin.value).to eq(8)
    end

    it 'is ruby' do
      coin = create(:coin, denom: 3)

      expect(coin.name).to eq('Ruby')
      expect(coin.value).to eq(15)
    end
  end

  describe "Associations" do

    it "belongs to a user" do
      coin = create(:coin, :with_user)

      expect(coin.user).to be_a(User)
    end

    it "belongs to a user_reward" do
      coin = create(:coin, :with_reward)

      expect(coin.user_reward).to be_a(UserReward)
    end
  end

  describe "Methods" do

    it "can be redeemed" do
      coin = create(:coin, :with_reward)
      expect(coin.redeemed?).to be_truthy
    end
  end
end
