require 'rails_helper'

feature 'User can delete his answer',  %q{
  In order to choose the best answer
  As an authenticated user
  I'd like to be able to mark as best my answer
} do

  given(:answer) {create(:answer)}

  scenario 'Authenticated user marks his answer', js: true do
    sign_in(answer.question.user)
    visit question_path(answer.question)

    expect(page).to have_content answer.body

    click_on 'Set as best'

    expect(page).to have_content 'This answer marked as the best'
  end

  scenario 'Authenticated user marks not his answer', js: true do
    sign_in(create(:user))
    visit question_path(answer.question)

    expect(page).to have_content answer.body
    expect(page).to_not have_link 'Set as best'
  end

  scenario 'Not authenticated user marks the answer', js: true do
    visit question_path(answer.question)

    expect(page).to have_content answer.body
    expect(page).to_not have_link 'Set as best'
  end
end
