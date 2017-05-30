require 'rails_helper'

RSpec.describe 'User visits account' do

  def login
    @user = create(:user, :with_all)
    @user.profile = create(:profile, first_name: 'Fuzzy', last_name: 'Lumpkin')
    visit(root_path)
    click_link('Login')
    expect(page).to have_current_path('/login')

    fill_in 'Username', :with => "#{@user.username}"
    fill_in 'Password', :with => "#{@user.password}"
    click_button 'Login'
  end

  it 'sees all of their coins' do
    login

    within(page.find('section', text: 'Coins')) do
      within(page.find(".widget-row", text: 'Rubies')) do
        expect(page).to have_content(10)
        expect(page).to have_content(150)
      end

      within(page.find(".widget-row", text: 'Gold')) do
        expect(page).to have_content(15)
        expect(page).to have_content(120)
      end

      within(page.find(".widget-row", text: 'Silver')) do
        expect(page).to have_content(20)
        expect(page).to have_content(60)
      end

      within(page.find(".widget-row", text: 'Copper')) do
        expect(page).to have_content(30)
        expect(page).to have_content(30)
      end

      within(page.find(".widget-row", text: 'Total')) do
        expect(page).to have_content(75)
        expect(page).to have_content(360)
      end
    end
  end

  it 'sees all of their awards' do
    login

    within(page.find(".widget-window-large", text: 'Claimed Rewards')) do
      expect(page).to have_content('Rock')
      expect(page).to have_content(7)
      expect(page).to have_content('Icecream')
      expect(page).to have_content(15)
    end
  end

  it 'sees all possible rewards' do
    create(:reward, cost: 100)
    create(:reward, cost: 50)
    create(:reward, cost: 200)
    create(:reward, cost: 350)
    create(:reward, cost: 361)

    login

    within(page.find(".widget-window-large", text: 'Ready Rewards')) do
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

    login
    
    within(page.find(".widget-window-large", text: 'All Rewards')) do
      expect(page).to have_content('Rock')
      expect(page).to have_content(100)
      expect(page).to have_content(50)
      expect(page).to have_content(600)
      expect(page).to have_content(1700)
    end
  end
end