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

  describe "User" do
    given(:question) { create(:question) }
    background do
      sign_in(question.user)

      visit question_path(question)
    end
    scenario 'can not vote for his own question' do
      expect(page).to have_content question.title
      expect(page).to_not have_link '+'
      expect(page).to_not have_link '-'
    end
  end
end
