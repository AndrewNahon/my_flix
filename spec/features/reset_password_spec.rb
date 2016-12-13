require 'spec_helper'

feature 'password reset' do 
  scenario 'user resets password and signs in with new password' do 
    andy = Fabricate(:user, password: 'password')

    submit_forgot_password_request(andy)

    reset_password('new password')

    sign_in_with_new_password(andy, 'new password')

    expect(page).to have_content andy.full_name
  end

  def submit_forgot_password_request(user)
    visit forgot_password_path
    fill_in "Email Address", with: user.email 
    click_button "Send Email"
    open_email user.email
    current_email.click_link 'Reset Password'
  end

  def reset_password(new_password)
    fill_in 'New Password', with: new_password
    click_button 'Reset Password'
  end

  def sign_in_with_new_password(user, new_password)
    fill_in 'Email Address', with: user.email
    fill_in 'Password', with: new_password
    click_button 'Sign in'
  end
end