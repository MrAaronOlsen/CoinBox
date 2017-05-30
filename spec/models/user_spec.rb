require 'rails_helper'

RSpec.describe User do

  describe 'Validations' do

    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username).case_insensitive  }
    it { should validate_presence_of(:role) }
    it { should have_secure_password }
    it { should have_one(:profile) }
    it { should have_many(:coins) }
    it { should have_many(:rewards).through(:user_rewards) }

    it 'is valid' do
      expect(build(:user)).to be_valid
    end

    it 'does not supply username' do
      user = build(:user, username: "")
      expect(user).to be_invalid
      expect(user.errors.full_messages).to eq(["Username can't be blank"])
    end

    it 'supplies existing username' do
      create(:user, username: 'THX1138')
      user = build(:user, username: "thx1138")
      expect(user).to be_invalid
      expect(user.errors.full_messages).to eq(["Username has already been taken"])
    end

    it 'does not supply password' do
      user = build(:user, password: "")
      expect(user).to be_invalid
      expect(user.errors.full_messages).to eq(["Password can't be blank", "Password is too short (minimum is 7 characters)"])
    end

    it 'does not supply long enough password' do
      user = build(:user, password: "pw")
      expect(user).to be_invalid
      expect(user.errors.full_messages).to eq(["Password is too short (minimum is 7 characters)"])
    end
  end

  describe 'associations' do

    it "has many coins" do
      user = create(:user, :with_coins)
      expect(user.coins.count).to eq(75)
    end

    it "has many rewards" do
      user = create(:user, :with_rewards, reward_count: 3)

      expect(user.rewards.count).to eq(3)
    end
  end

  describe "user rolls"
    it 'has a default roll of user' do
      user = create(:user)

      expect(user.role).to eq("user")
      expect(user.admin?).to be_falsey
      expect(user.user?).to be_truthy
    end

    it "can be created as an admin" do
      user = create(:user, :as_admin)

      expect(user.role).to eq('admin')
      expect(user.admin?).to be_truthy
      expect(user.user?).to be_falsey
    end
  end

  describe "claiming reward" do

    before do
      @user = create(:user, :with_coins)
      @reward = create(:reward, cost: 200)
    end

    it "can afford prize" do
      expect(@user.afford?(@reward)).to be_truthy
    end

    it "has coins" do
      expect(@user.money_in_box.count).to eq(75)
      expect(@user.money_in_box.sum(&:value)).to eq(360)
    end

    it "has denominations of coins" do
      denoms = @user.show_coins

      expect(denoms[3].count).to eq(30)
      expect(denoms[3].sum(&:value)).to eq(30)
      expect(denoms[2].count).to eq(20)
      expect(denoms[2].sum(&:value)).to eq(60)
      expect(denoms[1].count).to eq(15)
      expect(denoms[1].sum(&:value)).to eq(120)
      expect(denoms[0].count).to eq(10)
      expect(denoms[0].sum(&:value)).to eq(150)
    end

    it "can sum coins pulled from bag" do
      coins_in_hand = [ create(:coin, denom: 0),
                        create(:coin, denom: 1),
                        create(:coin, denom: 2),
                        create(:coin, denom: 3) ]

      expect(@user.count(coins_in_hand)).to eq(27)
    end

    it "can make change" do
      original_value = @user.money_in_box.sum(&:value)
      @user.make_change

      denoms = @user.show_coins
      expect(denoms[3].count).to eq(33)
      expect(denoms[3].sum(&:value)).to eq(33)
      expect(denoms[2].count).to eq(19)
      expect(denoms[2].sum(&:value)).to eq(57)

      values = [@user.money_in_box.sum(&:value)]
      19.times { @user.make_change }

      denoms = @user.show_coins
      expect(denoms[3].count).to eq(90)
      expect(denoms[3].sum(&:value)).to eq(90)
      expect(denoms[2].count).to eq(0)
      expect(denoms[2].sum(&:value)).to eq(0)

      values << @user.money_in_box.sum(&:value)
      @user.make_change

      denoms = @user.show_coins
      expect(denoms[3].count).to eq(98)
      expect(denoms[3].sum(&:value)).to eq(98)
      expect(denoms[1].count).to eq(14)
      expect(denoms[1].sum(&:value)).to eq(112)

      values << @user.money_in_box.sum(&:value)

      expect(values.all? { |value| value == original_value }).to be_truthy
    end

    it "can claim reward" do
      expect(@user.rewards).to be_empty
      expect(@user.money_in_box.sum(&:value)).to eq(360)

      user_reward = @user.claim(@reward)

      expect(@user.rewards.count).to eq(1)
      expect(@user.money_in_box.sum(&:value)).to eq(160)
    end

    it "can claim reward with only one coin larger than reward cost" do
      user = create(:user)
      reward = create(:reward, cost: 7)

      user.coins.create(denom: 3)
      user_reward = user.claim(reward)

      expect(user.money_in_box.sum(&:value)).to eq(8)
    end

    it "can't claim reward" do
      @user.claim(@reward)
      expect(@user.claim(@reward)).to be_falsey
    end
end