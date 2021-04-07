require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do

  given!(:question) {create(:question)}
  given(:user) {question.user}
  given(:google) { 'https://www.google.com/' }

  scenario 'User adds link when give an answer', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in 'Give an answer', with: 'My answer'

    fill_in 'Link name', with: 'google'
    fill_in 'Url', with: google

    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'google', href: google
    end
  end

end
