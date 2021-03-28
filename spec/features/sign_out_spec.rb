require 'rails_helper'

feature 'User can log out if he logged in' do
  scenario 'logout' do
    sign_in(create(:user))
    click_on 'logout'

    expect(page).to have_content 'Signed out successfully.'
  end
end