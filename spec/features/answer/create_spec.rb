require 'rails_helper'

feature 'User can answer the question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do

  given(:question) { create(:question) }

  describe "Authenticated user", js: true do

    background do
      sign_in(question.user)
      visit question_path(question)
    end

    scenario 'Authenticated user gives the answer' do
      fill_in 'Give an answer', with: 'New answer'
      click_on 'Answer'

      expect(page).to have_content 'New answer'
    end

    scenario 'Authenticated user gives the invalid answer' do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Not authenticated user gives the answer' do
    visit question_path(question)
    fill_in 'Give an answer', with: 'New answer'
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
 
