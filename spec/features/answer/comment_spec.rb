require 'rails_helper'

feature 'User can comment the answer' do

  given(:answer) { create(:answer) }

  describe "Authenticated user", js: true do

    background do
      sign_in(create(:user))
      visit question_path(answer.question)
    end

    scenario "comment answer" do
      within".answer" do
        fill_in 'Your comment:', with: 'new comment'
        click_on 'comment'
        expect(page).to have_content 'new comment'
      end
    end
  end

  context "mulitple sessions", js: true do
    scenario "answer appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(create(:user))
        visit question_path(answer.question)
      end

      Capybara.using_session('guest') do
        visit question_path(answer.question)
      end

      Capybara.using_session('user') do
        within".answer" do
          fill_in 'Your comment:', with: 'new comment'
          click_on 'comment'
          expect(page).to have_content 'new comment'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'new comment'
      end
    end
  end
end
