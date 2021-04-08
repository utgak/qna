require 'rails_helper'

feature 'User can delete link from his question' do

  given(:link) { create(:link) }

  describe "Authenticated user", js: true do

    background do
      sign_in(link.linkable.user)
      visit question_path(link.linkable)
    end

    scenario 'delete link', js: true do
      page.should have_link link.name
      click_on 'delete link'
      page.should_not have_link link.name
    end
  end

  describe "Not authenticated user", js: true do

    background do
      sign_in(create(:user))
      visit question_path(link.linkable)
    end

    scenario 'delete link', js: true do
      page.should have_link link.name
      page.should_not have_link "delete link"
    end
  end
end