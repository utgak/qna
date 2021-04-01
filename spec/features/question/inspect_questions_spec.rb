require 'rails_helper'

feature 'User can inspect all questions' do
  background { sign_in(create(:user)) }

  scenario 'inspect all questions' do
    create_list(:question, 3)
    visit questions_path
    expect(page).to have_content attributes_for(:question)[:title] * 3
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