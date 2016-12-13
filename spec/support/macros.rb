def set_current_user(user=nil)
  user = user || Fabricate(:user)
  session[:user_id] = user.id
end

def sign_in(a_user=nil)
  a_user = a_user || Fabricate(:user)
  visit sign_in_path
  fill_in "email", with: a_user.email 
  fill_in 'password', with: a_user.password
  click_button 'Sign in'
end

def sign_out 
  click_link 'Sign Out'
end
