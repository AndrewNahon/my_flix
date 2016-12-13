require 'spec_helper' 

feature "User invites friend" do 
  scenario 'user successfully invites a friend and invitation is accepted' do 
    andy = Fabricate(:user, password: 'password')
    sign_in andy 
    visit invite_friend_path 

    fill_in "Friend's Name", with: 'Joe Blow'
    fill_in "Friend's Email Address", with: 'joe@example.com'
    fill_in "Invitation Message", with: 'Join this site!'
    click_button 'Send Invitation'
    sign_out

    open_email('joe@example.com')
    current_email.click_link 'Click on this link to sign up!'

    fill_in 'Password', with: 'password'
    fill_in 'Full name', with: 'Joe Blow'
    click_button 'Sign Up'

    fill_in 'Email Address', with: 'joe@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign in'

    expect(page).to have_content 'Joe Blow'
    click_link 'People'

    expect(page).to have_content andy.full_name
    sign_out 

    sign_in andy 
    click_link 'People'
    expect(page).to have_content 'Joe Blow'

    clear_email
  end
end