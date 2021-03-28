require 'rails_helper'

feature 'User can delete question', %q{
  In order to delete question
  As an unauthenticated user
  I'd like to be able to delete my question
} do
  given(:user) {create(:user)}
  given(:question) { user.questions.create(body: 'text', title: 'title') }

  scenario 'delete my question' do
    user.questions.create(body: 'text', title: 'title')
    sign_in(user)
    visit questions_path
    click_on 'delete'

    expect(page).to have_content 'Question deleted'
    expect(page).to_not have_content question.title
  end
end