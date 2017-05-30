require 'rails_helper'

RSpec.describe 'User wants to log in' do

  it 'logs in first time with no user profile and fills in user profile' do
    user = create(:user)
    visit(root_path)
    click_link('Login')
    click_link('Create Account')
    expect(page).to have_current_path('/users/new')

    fill_in 'Username', :with => 'FuzzyLumpkin'
    fill_in 'Password', :with => 'password'
    click_button 'Create Account'

    expect(page).to have_current_path(login_path)
    expect(page).to have_content('User Successfully Created. Please Login.')
  end

  it 'logs in after making an account' do
    user = create(:user)

    visit login_path

    within('.login-form') do
      fill_in 'Username', :with => user.username
      fill_in 'Password', :with => user.password
      click_on('Login')
    end

    expect(page).to have_current_path("/users/#{user.id}/profiles/#{user.profile.id}/edit")
    expect(page).to have_content("Logged in as #{user.username}")

    within('form') do
      fill_in 'profile_first_name', with: 'Fuzzy'
      fill_in 'profile_last_name', with: 'Lumpkin'

      click_on 'Update Profile'
    end

    expect(user.role).to eq('user')
    expect(page).to have_current_path("/users/#{user.id}")
    expect(page).to have_content(user.username)
  end

  it 'logs in' do
    user = create(:user, profile: create(:profile, first_name: 'Fuzzy', last_name: 'Lumpkin'))

    visit('/login')

    within('.login-form') do
      fill_in 'Username', :with => user.username
      fill_in 'Password', :with => user.password
      click_on 'Login'
    end

    expect(user.role).to eq('user')
    expect(page).to have_content('Log Out')
    expect(page).to have_current_path("/users/#{user.id}")
    expect(page).to have_content(user.username)
  end

  it 'logs out' do
    user = create(:user, profile: create(:profile, first_name: 'Fuzzy', last_name: 'Lumpkin'))
    visit('/login')

    within('.login-form') do
      fill_in 'Username', :with => user.username
      fill_in 'Password', :with => user.password
      click_on 'Login'
    end

    click_link 'Log Out'

    expect(page).to have_current_path('/')
    expect(page).to have_content("Logged Out")
  end

end