require 'rails_helper'

RSpec.describe 'User visits account' do

  before do
    @user = create(:user, :with_all)
    visit(root_path)
    click_link('Login')
    expect(page).to have_current_path('/login')

    fill_in 'Username', :with => 'FuzzyLumpkin'
    fill_in 'Password', :with => 'password'
    click_button 'Login'
  end

  it 'sees all of their coins' do
    within_fieldset('coins') do
      within_fieldset('ruby') do
        expect(page).to have_content(10)
        expect(page).to have_content(150)
      end

      within_fieldset('gold') do
        expect(page).to have_content(15)
        expect(page).to have_content(120)
      end

      within_fieldset('silver') do
        expect(page).to have_content(20)
        expect(page).to have_content(60)
      end

      within_fieldset('copper') do
        expect(page).to have_content(30)
        expect(page).to have_content(30)
      end

      within_fieldset('total') do
        expect(page).to have_content(75)
        expect(page).to have_content(360)
      end
  end

  it 'sees all of their awards' do
    within_fieldset('awards') do
      expect(page).to have_content('Rock')
      expect(page).to have_content(7)
      expect(page).to have_content('Icecream')
      expect(page).to have_content(15)
    end
  end

  it 'sees all possible awards' do
    create(:reward, cost: 100)
    create(:reward, cost: 50)
    create(:reward, cost: 200)
    create(:reward, cost: 350)
    create(:reward, cost: 361)

    within_fieldset('ready-awards') do
      expect(page).to have_content('Rock')
      expect(page).to have_content(100)
      expect(page).to have_content(50)
      expect(page).to have_content(200)
      expect(page).to have_content(350)
      expect(page).to_not have_content(361)
    end
  end

  it 'sees all awards' do
    create(:reward, cost: 100)
    create(:reward, cost: 50)
    create(:reward, cost: 600)
    create(:reward, cost: 1700)

    within_fieldset('all-awards') do
      expect(page).to have_content('Rock')
      expect(page).to have_content(100)
      expect(page).to have_content(50)
      expect(page).to have_content(600)
      expect(page).to have_content(1700)
    end
  end