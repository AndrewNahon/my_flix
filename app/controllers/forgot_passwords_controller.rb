
class ForgotPasswordsController < ApplicationController 
  def new; end

  def create
    user = User.find_by(email: params[:email])
    if user 
      user.generate_token
      AppMailer.send_reset_password_email(user).deliver
    else
      flash[:danger] = params[:email].empty? ? 'You must submit an email address' : 'That email address is not registered.'
    end
    redirect_to forgot_password_path
  end
end