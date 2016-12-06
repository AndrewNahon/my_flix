
class SessionsController < ApplicationController
  before_filter :require_user, only: [:destroy]
  def new 
    redirect_to home_path if logged_in?
  end

  def create
    user = User.find_by( email: params[:email] )

    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "You are now logged in."
      redirect_to home_path
    else
      flash[ :danger] = 'There was a problemo with your email address or password.'
      redirect_to sign_in_path
    end
  end

  def destroy
    if logged_in?
      session[:user_id] = nil
      flash[:success] = 'You have successfully signed out.'
    end
    redirect_to sign_in_path
  end
end