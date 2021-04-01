require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
} do

  given!(:answer) { create(:answer) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(answer.question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his answer', js: true do
      sign_in answer.user
      visit question_path(answer.question)

      click_on 'Edit'


      within '.answers' do
        fill_in 'Give an answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors', js: true do

      sign_in answer.user
      visit question_path(answer.question)

      click_on 'Edit'


      within '.answers' do
        fill_in 'Give an answer', with: ''
        click_on 'Save'
      end
      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's question", js: true do
      sign_in create(:user)
      visit question_path(answer.question)
      expect(page).to_not have_link 'Edit'
    end
  end
end
