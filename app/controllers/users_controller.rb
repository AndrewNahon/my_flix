class UsersController < ApplicationController
  before_filter :require_user, except: [:new, :create]
  
  def new 
    @user = User.new
  end

  def show 
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    @invitation = Invitation.find_by( token: params[:token] )

    if @user.save
      process_invitation

      AppMailer.send_welcome_email(@user).deliver
      flash[:success] = "You have successfully registered #{@user.full_name}!"
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

  def process_invitation 
    if @invitation
      @user.follow(@invitation.user)
      @invitation.user.follow(@user)
      @invitation.update_attribute(:token, nil)
    end
  end
end