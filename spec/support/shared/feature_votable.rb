require 'rails_helper'

shared_examples 'feature votable' do
  scenario 'vote up' do
    click_on '+'

    within '.voting-result' do
      expect(page).to have_content '1'
    end
  end

  scenario 'vote down' do
    click_on '-'

    within '.voting-result' do
      expect(page).to have_content '-1'
    end
  end

  scenario 'revote' do
    click_on '+'

    within '.voting-result' do
      expect(page).to have_content '1'
    end

    click_on '-'

    within '.voting-result' do
      expect(page).to have_content '-1'
    end
  end
end