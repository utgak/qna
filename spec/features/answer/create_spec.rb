require 'rails_helper'

feature 'User can answer the question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do

  given(:question) { create(:question) }

  describe "Authenticated user", js: true do

    background do
      sign_in(question.user)
      visit question_path(question)
    end

    scenario 'Authenticated user gives the answer' do
      fill_in 'Give an answer', with: 'New answer'
      click_on 'Answer'

      expect(page).to have_content 'New answer'
    end

    scenario 'Authenticated user gives the invalid answer' do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end


    scenario 'ask a question with attached file' do
      fill_in 'Give an answer', with: 'New answer'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Not authenticated user gives the answer' do
    visit question_path(question)
    fill_in 'Give an answer', with: 'New answer'
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  context "mulitple sessions", js: true do
    scenario "answer appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(create(:user))
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Give an answer', with: 'Test answer'
        click_on 'Answer'

        expect(page).to have_content 'Test answer'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test answer'
      end
    end
  end
end
 
