require 'rails_helper'

feature 'User can sign up if he want to' do
  scenario 'sign up' do
    visit root_path
    click_on 'sign_up'
    fill_in 'Email', with: 'asdf@gmail.com'
    fill_in 'Password', with: 'asdf@gmail.com'
    fill_in 'Password confirmation', with: 'asdf@gmail.com'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
end
