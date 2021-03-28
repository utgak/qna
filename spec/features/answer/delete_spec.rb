require 'rails_helper'

feature 'User can delete his answer', %q{
  In order to delete the answer
  As an authenticated user
  I'd like to be able to delete my answer
} do

  given(:answer) {create(:answer)}

  scenario 'Authenticated user deletes the answer' do
    sign_in(answer.user)
    visit question_path(answer.question)


    click_on 'delete'

    expect(page).to_not have_content answer.body
  end
end
