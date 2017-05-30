require 'rails_helper'

RSpec.describe 'User wants to update profile' do

  it 'does not update with valid input' do
    user = create(:user, :with_profile)
    visit('/login')

    fill_in 'Username', :with => 'FuzzyLumpkin'
    fill_in 'Password', :with => 'password'
    click_button 'Login'

    within_fieldset "user-#{user.id}" do
      click_link 'FuzzyLumpkin'
    end

    expect(page).to have_current_path('/user/#{user.id}/profile')

    click_link 'Edit Profile'

    fill_in 'First Name', :with => ''
    fill_in 'Last Name', :with => ''

    click_link 'Update Profile'

    expect(page).to have_content('First Name cannot be blank')
    expect(page).to have_content('Last Name cannot be blank')
  end

  it 'updates profile' do
    user = create(:user, :with_profile)
    visit('/login')

    fill_in 'Username', :with => 'FuzzyLumpkin'
    fill_in 'Password', :with => 'password'
    click_button 'Login'

    within_fieldset "user-#{user.id}" do
      click_link 'FuzzyLumpkin'
    end

    click_link 'Edit Profile'

    fill_in 'First Name', :with => 'Furry'
    fill_in 'Last Name', :with => 'Pumpkin'

    click_link 'Update Profile'

    expect(page).to have_current_path('/user/#{user.id}/profile')
    expect(page).to have_content('Furry Bumpkin')
  end