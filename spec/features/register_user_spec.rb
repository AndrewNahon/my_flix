require 'spec_helper'

feature 'register new user' do 
  scenario 'new user registers' do 
    visit register_path
    fill_in 'user_email', with: 'andy@example.com'
    fill_in 'user_password', with: 'password'
    fill_in 'user_full_name', with: 'Andrew Nahon'
    click_button 'Sign Up'

    fill_in "email", with: 'andy@example.com' 
    fill_in 'password', with: 'password'
    click_button 'Sign in'

    expect(page).to have_content 'Andrew Nahon'

  end
end