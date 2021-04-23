require 'rails_helper'

feature 'User can vote for answer', js: true do
  describe 'Authenticated user' do
    background do
      sign_in(create(:user))

      visit question_path(create(:answer).question)
    end

    it_behaves_like 'feature votable'
  end

  describe "User" do
    given(:answer) { create(:answer) }
    background do
      sign_in(answer.user)

      visit question_path(answer.question)
    end
    scenario 'can not vote for his own answer' do
      expect(page).to have_content answer.body
      expect(page).to_not have_link '+'
      expect(page).to_not have_link '-'
    end
  end
end
