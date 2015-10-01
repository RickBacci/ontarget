require 'rails_helper'

feature "User" do
  include OmniAuthUser

  before do
    OmniAuth.config.mock_auth[:github] = nil
    stub_omniauth
  end

  scenario "can logout and destroy the session" do
    VCR.use_cassette("loggout") do
      visit root_path

      expect(page).to_not have_link('Logout')

      click_on "Login"

      expect(page).to have_link('Logout')

      click_on "Logout"

      expect(page).to have_link('Login')
    end
  end
end

