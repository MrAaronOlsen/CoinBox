require 'rails_helper'

RSpec.describe 'User wants to create account' do

  it 'creates a valid new user' do
    visit(root_path)
    click_link('Login')
    expect(page).to have_current_path('login')

    click_link('New User')
    expect(page).to have_current_path('users/new')

    fill_in 'Username', :with => 'FuzzyLumpkin'
    fill_in 'Password', :with => 'password'
    click_button 'Create User'

    expect(user.roll).to eq('user')
    expect(page).to have_content('Account for FuzzyLumpkin has been created')
    expect(page).to have_current_path('login')
  end

  it 'creates an invalid new user' do
    create(:user, :with_profile)
    visit('users/new')

    fill_in 'Username', :with => 'FuzzyLumpkin'
    fill_in 'Password', :with => ''
    click_button 'Create User'

    expect(page).to have_current_path('users')
    expect(page).to have_content('Username must be unique')
    expect(page).to have_content("Password can't be blank")

    fill_in 'Username', :with => 'FuzzyBumpkin'
    fill_in 'Password', :with => 'pw'

    expect(page).to have_current_path('users')
    expect(page).to have_content('FuzzyBumpkin')
    expect(page).to have_content('Password is too short (minimum is 8 characters)')
  end

end