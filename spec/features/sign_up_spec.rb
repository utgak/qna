require 'rails_helper'

feature 'User can sign up if he want to' do
  background do
    visit root_path
    click_on 'sign_up'
  end
  scenario 'sign up' do
    fill_in 'Email', with: 'asdf@gmail.com'
    fill_in 'Password', with: 'asdf@gmail.com'
    fill_in 'Password confirmation', with: 'asdf@gmail.com'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'invalid sign up' do
    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
  end
end
