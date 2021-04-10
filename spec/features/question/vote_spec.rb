require 'rails_helper'

feature 'User can vote for question', js: true do
  describe 'Authenticated user' do
    background do
      create(:question)
      sign_in(create(:user))

      visit questions_path
    end

    scenario 'vote up' do
      click_on '+'

      within '.voting-result' do
        expect(page).to have_content '1'
      end
    end

    scenario 'vote down' do
      click_on '-'

      within '.voting-result' do
        expect(page).to have_content '-1'
      end
    end

    scenario 'revote' do
      click_on '+'

      within '.voting-result' do
        expect(page).to have_content '1'
      end

      click_on '-'

      within '.voting-result' do
        expect(page).to have_content '-1'
      end
    end
  end
end
