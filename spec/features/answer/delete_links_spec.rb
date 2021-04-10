require 'rails_helper'

feature 'User can delete link from his answer' do

  given(:link) { create(:link, :linkable_answer) }

  describe "Authenticated user", js: true do

    background do
      sign_in(link.linkable.user)
      visit question_path(link.linkable.question)
    end

    scenario 'delete link', js: true do
      expect(page).to have_link link.name
      click_on 'delete link'
      expect(page).to_not have_link link.name
    end
  end

  describe "Not authenticated user", js: true do

    background do
      sign_in(create(:user))
      visit question_path(link.linkable.question)
    end

    scenario 'delete link', js: true do
      expect(page).to have_link link.name
      expect(page).to_not have_link "delete link"
    end
  end
end
