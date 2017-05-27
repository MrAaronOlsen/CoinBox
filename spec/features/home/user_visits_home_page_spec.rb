require 'rails_helper'

RSpec.describe "user visits home page" do

  it 'sees the home page' do
    visit(root_path)

    expect(page).to have_current_path("/")
    expect(page).to have_content("CoinBox")
    expect(page).to have_content("Login")

    expect(page).to_not have_content("Logged in as")
  end