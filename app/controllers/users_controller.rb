class UsersController < ApplicationController
  before_filter :require_user, except: [:new, :create]
  
  def new 
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save 
      flash[:notice] = "You have successfully registered #{@user.full_name}!"
      redirect_to sign_in_path
    else 
      flash[:danger] = 'Please fill out the form correctly.'
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :email, :full_name)
  end
end