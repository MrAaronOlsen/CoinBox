require 'rails_helper'

RSpec.describe User do

  describe 'Validations' do

    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:roll) }
    it { should have_secure_password }
    it { should have_one(:user_profile) }
    it { should have_many(:coins) }
    it { should have_many(:rewards).through(:user_rewards) }

    it 'is valid' do
      expect(build(:user)).to be_valid
    end

    it 'does not supply username' do
      user = build(:user, username: "")
      expect(user).to be_invalid
      expect(user.errors.full_messages).to eq("Username can't be blank")
    end

    it 'supplies existing username' do
      create(:user, username: 'THX1138')
      user = build(:user, username: "thx1138")
      expect(user).to be_invalid
      expect(user.errors.full_messages).to eq("Username can't be blank")
    end

    it 'does not supply password' do
      user = build(:user, password: "")
      expect(user).to be_invalid
      expect(user.errors.full_messages).to eq("Password can't be blank")
    end

    it 'does not supply long enough password' do
      user = build(:user, password: "pw")
      expect(user).to be_invalid
      expect(user.errors.full_messages).to eq("Password must be at least 8")
    end
  end

  describe 'associations' do

    it "has many coins" do
      user = (:user, :with_coins)

      expect(user.coins.count).to eq(75)
    end

    it "has many rewards" do
      user = (:user, :with_rewards, reward_count: 3)

      expec(user.rewards.count).to eq(3)
    end
  end

  describe "user rolls"
    it 'has a default roll of user' do
      user = create(:user)

      expect(user.roll).to eq("user")
      expect(user.admin?).to be_falsey
      expect(user.default?).to be_truthy
    end

    it "can be created as an admin" do
      user = create(:user, :as_admin)

      expect(user.role).to eq('admin')
      expect(user.admin?).to be_truthy
    end
  end

  describe "claiming reward" do

    before do
      @user = create(:user, :with_coins)
      @reward = create(:reward)
    end

    # before do
    #   @user = User.create(username: "Fuzzy Lumpkin")
    #   @reward = Reward.create(name: "Buzz Lightyear",
    #                           desc: "To the stars and beyond!",
    #                           cost: "234",
    #                           kind: 1)
    #
    #   30.times { Point.create(value: 1) }
    #   20.times { Point.create(value: 3) }
    #   15.times { Point.create(value: 8) }
    #   10.times { Point.create(value: 15) }
    #
    #   points = Point.all
    #   @user.points << points
    # end

    it "can afford prize" do
      expect(@user.afford?(@reward)).to be_truthy
    end

    it "has money_bag" do
      expect(@user.money_bag.count).to eq(75)
      expect(@user.money_bag.sum(:value)).to eq(360)
    end

    it "has a money_bag" do
      money_bag = @user.coins
      expect(money_bag[3][:coins].count).to eq(30)
      expect(money_bag[3][:coins].sum(:value)).to eq(30)
      expect(money_bag[2][:coins].count).to eq(20)
      expect(money_bag[2][:coins].sum(:value)).to eq(60)
      expect(money_bag[1][:coins].count).to eq(15)
      expect(money_bag[1][:coins].sum(:value)).to eq(120)
      expect(money_bag[0][:coins].count).to eq(10)
      expect(money_bag[0][:coins].sum(:value)).to eq(150)
    end

    it "can sum coins pulled from bag" do
      open_bag = @user.coins
      coins = [open_bag[0][:coins].first,
               open_bag[1][:coins].first,
               open_bag[2][:coins].first,
               open_bag[3][:coins].first]

      expect(@user.total_value(coins)).to eq(27)
    end

    it "can make change" do
      original_value = @user.money_bag.sum(:value)
      @user.make_change

      open_bag = @user.coins
      expect(open_bag[3][:coins].count).to eq(33)
      expect(open_bag[3][:coins].sum(:value)).to eq(33)
      expect(open_bag[2][:coins].count).to eq(19)
      expect(open_bag[2][:coins].sum(:value)).to eq(57)

      values = [@user.money_bag.sum(:value)]
      19.times { @user.make_change }

      open_bag = @user.coins
      expect(open_bag[3][:coins].count).to eq(90)
      expect(open_bag[3][:coins].sum(:value)).to eq(90)
      expect(open_bag[2][:coins].count).to eq(0)
      expect(open_bag[2][:coins].sum(:value)).to eq(0)

      values << @user.money_bag.sum(:value)
      @user.make_change

      open_bag = @user.coins
      expect(open_bag[3][:coins].count).to eq(98)
      expect(open_bag[3][:coins].sum(:value)).to eq(98)
      expect(open_bag[1][:coins].count).to eq(14)
      expect(open_bag[1][:coins].sum(:value)).to eq(112)

      values << @user.money_bag.sum(:value)

      expect(values.all? { |value| value == original_value }).to be_truthy
    end

    it "can claim reward" do
      expect(@user.rewards).to be_empty
      expect(@user.money_bag.sum(:value)).to eq(360)
      user_reward = @user.claim(@reward)
      expect(@user.rewards.count).to eq(1)
      expect(@user.money_bag.sum(:value)).to eq(126)

      expect(user_reward.reward).to eq(@reward)
      expect(user_reward.user).to eq(@user)
      expect(user_reward.points.sum(:value)).to eq(234)
    end

    it "can claim reward with only one coin larger than reward cost" do
      user = create(:user)
      reward = create(:reward, cost: 7)

      user.points.create(value: 15)
      user_reward = user.claim(reward)

      expect(user.money_bag.sum(:value)).to eq(8)
    end

    it "can't claim reward" do
      @user.claim(@reward)
      expect(@user.claim(@reward)).to be_falsey
    end
end