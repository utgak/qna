require 'rails_helper'

feature 'User can delete files from his question' do

  given(:question) { create(:question) }

  describe "delete file", js: true do

    background do
      sign_in(question.user)
      visit questions_path
      click_on 'edit'
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
      click_on 'Ask'
      expect(page).to have_link 'rails_helper.rb'
    end

    scenario 'delete file', js: true do
      click_on 'delete_file'
      expect(page).to_not have_link 'rails_helper.rb'
    end
  end
end
