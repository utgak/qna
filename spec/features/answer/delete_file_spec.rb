require 'rails_helper'

feature 'User can delete files from his answer' do

  given(:answer) { create(:answer) }
  describe "Authenticated user", js: true do

    background do
      sign_in(answer.user)
      visit question_path(answer.question)
      click_on 'Edit'
      within '.answers' do
        attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
        click_on 'Save'
      end
    end

    scenario 'delete file', js: true do
      within '.answers' do
        click_on 'delete_file'
        expect(page).to_not have_link 'rails_helper.rb'
      end
    end
  end
end
