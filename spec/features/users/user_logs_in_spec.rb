require 'rails_helper'

RSpec.describe 'User wants to log in' do

  it 'logs in first time with no user profile and fills in user profile' do
    user = create(:user)
    visit(root_path)
    click_link('Login')
    expect(page).to have_current_path('/login')

    fill_in 'Username', :with => 'FuzzyLumpkin'
    fill_in 'Password', :with => 'password'
    click_button 'Login'

    expect(page).to have_current_path("user/#{user.id}/profile")
    expect(page).to have_content('Please fill in your profile')

    fill_in 'First Name', with: 'Fuzzy'
    fill_in 'Last Name', with: 'Lumpkin'

    click_link 'Update Profile'

    expect(user.roll).to eq('user')
    expect(page).to have_current_path("user/#{user.id}")
    expect(within_fieldset "user-#{user.id}").to have_content('FussyLumpkin')
  end

  it 'logs in' do
    user = create(:user, :with_profile)
    visit('/login')

    fill_in 'Username', :with => 'FuzzyLumpkin'
    fill_in 'Password', :with => 'password'
    click_button 'Login'

    expect(user.roll).to eq('user')
    expect(page).to have_current_path("user/#{user.id}")
    expect(page).to have_content('Welcome back FuzzyLumpkin')
  end

  it 'logs out' do
    user = create(:user, :with_profile)
    visit('/login')

    fill_in 'Username', :with => 'FuzzyLumpkin'
    fill_in 'Password', :with => 'password'
    click_button 'Login'

    click_button 'Logout'

    expect(page).to have_current_path('/')
    expect(page).to have_content("Logged Out")
  end

end