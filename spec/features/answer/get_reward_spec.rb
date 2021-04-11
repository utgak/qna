require 'rails_helper'

feature 'User can get a reward for answering' do

  describe 'Authenticated user marks his answer', js: true do
    given!(:reward)  { create(:reward) }
    given(:answer) { create(:answer) }

    scenario 'User marks best answer' do
      reward.question.answers.push(answer)
      sign_in(reward.question.user)
      visit question_path(reward.question)

      expect(page).to have_content answer.body
      expect(page).to have_content reward.name
      expect(page).to have_xpath("//img[contains(@src, \"img.png\")]")

      click_on 'Set as best'

      expect(page).to have_content 'This answer marked as the best'
    end

    scenario 'user can inspect his awards' do
      user = create(:user)
      user.rewards.push(reward)
      sign_in(user)
      visit rewards_path

      expect(page).to have_content reward.question.title
      expect(page).to have_content reward.name
      expect(page).to have_xpath("//img[contains(@src, \"img.png\")]")
    end
  end
end
