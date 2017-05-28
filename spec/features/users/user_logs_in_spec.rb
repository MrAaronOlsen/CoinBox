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

  xit 'logs in for after making an account' do
    user = create(:user)

    visit(login_path)

    fill_in 'Username', :with => 'FuzzyLumpkin'
    fill_in 'Password', :with => 'password'
    click 'Login'

    expect(page).to have_current_path(edit_user_profile(user, user.profile))
    expect(page).to have_content("Logged in as #{user.username}")

    fill_in 'First Name', with: 'Fuzzy'
    fill_in 'Last Name', with: 'Lumpkin'

    click_link 'Update Profile'

    expect(user.roll).to eq('user')
    expect(page).to have_current_path("user/#{user.id}")
    expect(within_fieldset "user-#{user.id}").to have_content('FussyLumpkin')
  end

  xit 'logs in' do
    user = create(:user, :with_profile)
    visit('/login')

    fill_in 'Username', :with => 'FuzzyLumpkin'
    fill_in 'Password', :with => 'password'
    click_button 'Login'

    expect(user.roll).to eq('user')
    expect(page).to have_current_path("user/#{user.id}")
    expect(page).to have_content('Welcome back FuzzyLumpkin')
  end

  xit 'logs out' do
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