require 'rails_helper'

feature 'User can vote for question', js: true do
  describe 'Authenticated user' do
    background do
      create(:question)
      sign_in(create(:user))

      visit questions_path
    end
    it_behaves_like 'feature votable'
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
