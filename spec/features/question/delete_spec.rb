require 'rails_helper'

feature 'User can delete question', %q{
  In order to delete question
  As an unauthenticated user
  I'd like to be able to delete my question
} do
  given(:user) {create(:user)}
  background do
    user.questions.create(attributes_for(:question))
    visit questions_path
  end

  scenario 'delete my question' do
    sign_in(user)

    expect(page).to have_content attributes_for(:question)[:title]

    click_on 'delete'

    expect(page).to have_content 'Question deleted'
    expect(page).to_not have_content attributes_for(:question)[:title]
  end

  scenario 'not authorized user delete the question' do
    expect(page).to have_content attributes_for(:question)[:title]
    expect(page).to_not have_link 'delete'
  end

  scenario 'authorized user delete not his question' do
    sign_in(create(:user))

    expect(page).to have_content attributes_for(:question)[:title]
    expect(page).to_not have_link 'delete'
  end
end