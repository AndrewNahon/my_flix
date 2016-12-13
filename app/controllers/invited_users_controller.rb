class InvitedUsersController < ApplicationController
  def new
    @invitation = Invitation.find_by(token: params[:token] )
    @user = User.new 
    @user.email = @invitation.friend_email if @invitation
  end
end