require 'pry'

class RelationshipsController < ApplicationController
  before_filter :require_user
  
  def index
    @following = current_user.following
  end

  def create
    Relationship.create(follower: current_user, followed_user: User.find(params[:id]))
    redirect_to people_path
  end
end