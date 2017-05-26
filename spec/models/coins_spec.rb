require 'rails_helper'

RSpec.describe Coin do

  describe 'Validations' do

    it { should validate_presence_of(:type) }
    it { should belong_to(:user) }
    it { should belong_to(:user_reward) }

    it 'is valid' do
      expect(build(:coin)).to be_valid
    end

    it 'does not supply a type' do
      coin = build(:coin, type: "")
      expect(coin).to be_invalid
      expect(coin.errors.full_messages).to eq("Type can't be blank")
    end

    it 'supplies type is out of range' do
      coin = build(:coin, type: 5)
      expect(coin).to be_invalid
      expect(coin.errors.full_messages).to eq("Type can't be greater than 4")
    end
  end

  describe 'Point types and value enums' do

    it 'is copper' do
      coin = create(:coin, type: 0)

      expect(coin.type).to eq('copper')
      expect(coin.value).to eq(1)
    end

    it 'is silver' do
      coin = create(:coin, type: 1)

      expect(coin.type).to eq('silver')
      expect(coin.value).to eq(3)
    end

    it 'is gold' do
      coin = create(:coin, type: 2)

      expect(coin.type).to eq('gold')
      expect(coin.value).to eq(8)
    end

    it 'is ruby' do
      coin = create(:coin, type: 3)

      expect(coin.type).to eq('ruby')
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

      expect(coin.reward).to be_a(Reward)
    end
  end

  describe "Methods" do

    it "can be redeemed" do
      coin = create(:coin, :with_reward)
      expect(coin.redeemed?).to be_truthy
    end

    it "can not belong to a redeemed reward" do
      reward = create(:reward, :redeemed)
      coin = create(:coin)

      reward.coins << coin

      expect(coin.reward).to be_falsey
    end
  end
end