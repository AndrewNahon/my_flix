class AppMailer < ActionMailer::Base
  
  def send_welcome_email(user)
    @user = user
    mail to: @user.email, from: 'information@example.com', subject: 'Welcome to MyFlix!'
  end

  def send_reset_password_email(user)
    @user = user
    mail to: user.email, from: 'information@example.com', subject: 'Reset MyFlix Password'
  end

  def send_invitation_email(invitation)
    @invitation = invitation 
    mail to: @invitation.friend_email, from: 'information@example.com', subject: 'Invitation to Join MyFlix!'
  end
end