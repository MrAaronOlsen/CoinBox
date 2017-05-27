require 'rails_helper'

RSpec.describe Profile do

  describe 'Validations' do

    it { should belong_to(:user) }

    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }

    it 'is valid' do
      expect(build(:profile)).to be_valid
    end

    it 'does not supply first name' do
      profile = build(:profile, first_name: "")
      expect(profile).to be_invalid
      expect(profile.errors.full_messages).to eq(["First name can't be blank"])
    end

    it 'does not supply last name' do
      profile = build(:profile, last_name: "")
      expect(profile).to be_invalid
      expect(profile.errors.full_messages).to eq(["Last name can't be blank"])
    end
  end

  describe 'Associations' do

    it 'has one user' do
      profile = build(:profile)

      expect(profile.user).to be_a(User)
    end
  end
end