require 'rails_helper'

feature 'User can delete his answer',  %q{
  In order to delete the answer
  As an authenticated user
  I'd like to be able to delete my answer
} do

  given(:answer) {create(:answer)}

  scenario 'Authenticated user deletes his answer', js: true do
    sign_in(answer.user)
    visit question_path(answer.question)

    expect(page).to have_content answer.body

    click_on 'delete'

    expect(page).to_not have_content answer.body
  end

  scenario 'Authenticated user deletes not his answer', js: true do
    sign_in(create(:user))
    visit question_path(answer.question)

    expect(page).to have_content answer.body
    expect(page).to_not have_link "delete"
  end

  scenario 'Not authenticated user deletes the answer', js: true do
    visit question_path(answer.question)

    expect(page).to have_content answer.body
    expect(page).to_not have_link "delete"
  end
end
