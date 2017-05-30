include 'rails_helper'

RSpec.describe 'User wants to claim reward' do

  before do
    @reward = create(:reward, cost: 100, name: 'Thingy')
    @user = create(:user, :with_all)
    visit(root_path)
    click_link('Login')
    expect(page).to have_current_path('/login')

    fill_in 'Username', :with => 'FuzzyLumpkin'
    fill_in 'Password', :with => 'password'
    click_button 'Login'
  end

  it 'views a reward it can claim' do
    within_fieldset('ready-awards') do
      click_link "reward-#{reward.id}"
    end

    expect(page).to have_current_path("/user/#{@user.id}/reward/#{@reward.id}")
    expect(page).to have_content("It's Friendly!")
    expect(page).to have_content(100)
    page.should have_css("claim-reward")
  end

  it 'views on a reward it cannot claim' do
    reward2 = create(:reward, cost: 1200)
    within_fieldset('all-awards') do
      click_link "reward-#{reward2.id}"
    end

    expect(page).to have_current_path("/user/#{@user.id}/reward/#{reward2.id}")
    expect(page).to have_content("It's Friendly!")
    expect(page).to have_content(1200)
    page.should have_css("claim-reward[disabled]")
  end

  it 'claims a reward' do
    visit("/user/#{@user.id}/reward/#{@reward.id}")

    click_link('claim-reward')

    expect(page).to have_current_path("/user/#{@user.id}")

    within_fieldset('awards') do
      expect(page).to have_content('Thingy')
      expect(page).to have_content(100)
    end

    within_fieldset('coins') do
      within_fieldset('total') do
        expect(page).to have_content(260)
      end
    end
  end
end