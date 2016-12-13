require 'pry'

class ResetPasswordsController < ApplicationController
  def new
    @token = params[:token]
    redirect_to invalid_token_path unless User.find_by(token: @token)
  end

  def create 
    user = User.find_by(token: params[:token])
    if user 
      user.password = params[:password]
      user.save
      user.update_attribute(:token, nil)
      flash[:success] = 'Your password was successfully changed.'
    else
      return redirect_to invalid_token_path
    end
    redirect_to sign_in_path
  end
end