require 'rails_helper'

feature 'User can inspect all questions' do
  scenario 'inspect all questions' do
    list = create_list(:question, 3)
    sign_in(create(:user))
    visit questions_path
    expect(page).to have_content attributes_for(:question)[:title] * 3
  end

  scenario 'User can inspect question and answers' do
    question = create(:question)
    user = create(:user)
    3.times { question.answers.create(question: question, user: user, body: 'answer_body') }
    sign_in(create(:user))
    visit question_path(question)

    expect(page).to have_content 'answer_body' * 3
    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end
end