require 'rails_helper'

RSpec.describe UserProfile do

  describe 'Validations' do

    it { should have_many(:coins) }
    it { should belong_to(:reward) }
    it { should belong_to(:user) }
  end
end