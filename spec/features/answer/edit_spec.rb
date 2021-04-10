require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
} do

  given!(:answer) { create(:answer) }
  given(:google) { 'https://www.google.com/' }

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

    scenario 'add files with editing', js: true do
      sign_in answer.user
      visit question_path(answer.question)

      click_on 'Edit'

      within '.answers' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
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

    scenario 'edits his answer and add link', js: true do
      sign_in answer.user
      visit question_path(answer.question)

      click_on 'Edit'


      within '.answers' do
        click_on 'add link'
        fill_in 'Link name', with: 'google'
        fill_in 'Url', with: google
        click_on 'Save'
        expect(page).to have_link 'google'
      end
    end


    scenario "tries to edit other user's question", js: true do
      sign_in create(:user)
      visit question_path(answer.question)
      expect(page).to_not have_link 'Edit'
    end
  end
end
