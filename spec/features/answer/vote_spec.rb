require 'rails_helper'

feature 'User can vote for answer', js: true do
  describe 'Authenticated user' do
    background do
      sign_in(create(:user))

      visit question_path(create(:answer).question)
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
