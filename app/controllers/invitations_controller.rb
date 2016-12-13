class InvitationsController < ApplicationController
  before_filter :require_user

  def new
    @invitation = Invitation.new
  end

  def create
    invitation_atts = { user: current_user, 
                        friend_name: params[:friend_name],
                        friend_email: params[:friend_email],
                        message: params[:message] }
    @invitation = Invitation.new(invitation_atts)
    
    if @invitation.save
      AppMailer.send_invitation_email(@invitation).deliver
      flash[:success] = 'Your invitation was successfully sent.'
    else
      flash[:danger] = "There was a problem with your form inputs."
    end
    redirect_to invite_friend_path
  end
end