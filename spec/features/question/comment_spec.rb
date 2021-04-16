require 'rails_helper'

feature 'User can comment the question' do

  given(:question) { create(:question) }

  describe "Authenticated user", js: true do

    background do
      sign_in(create(:user))
      visit question_path(question)
    end

    scenario "comment question" do
      within".question_comments_form" do
        fill_in 'Your comment:', with: 'new comment'
        click_on 'comment'
      end
      expect(page).to have_content 'new comment'
    end
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
        within".question_comments_form" do
          fill_in 'Your comment:', with: 'new question comment'
          click_on 'comment'
        end
        expect(page).to have_content 'new question comment'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'new question comment'
      end
    end
  end
end
