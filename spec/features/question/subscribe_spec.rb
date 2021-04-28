require 'rails_helper'

feature 'User can subscribe the question' do

  given(:question) { create(:question) }

  describe "Authenticated user" do
    background do
      sign_in(create(:user))
      visit question_path(question)
    end

    scenario 'subscribe' do
      click_on "Subscribe"
      expect(page).to have_content "You successfully subscribed"
    end

    scenario 'unsubscribe' do
      click_on "Subscribe"
      click_on "Unsubscribe"
      expect(page).to have_content "You successfully unsubscribed"
    end
  end
end
