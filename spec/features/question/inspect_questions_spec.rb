require 'rails_helper'

feature 'User can inspect all questions' do
  background { sign_in(create(:user)) }

  scenario 'inspect all questions' do
    create(:question, title: 'title1')
    create(:question, title: 'title2')
    create(:question, title: 'title3')

    visit questions_path
    expect(page).to have_content "title1"
    expect(page).to have_content "title2"
    expect(page).to have_content "title3"
  end

  scenario 'User can inspect question and answers' do
    question = create(:question)
    user = create(:user)
    question.answers.create(question: question, user: user, body: 'answer_body')
    visit question_path(question)

    expect(page).to have_content 'answer_body'
    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end
end