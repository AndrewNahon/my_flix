
class RelationshipsController < ApplicationController
  before_filter :require_user
  
  def index
    @followed_user_relationships = current_user.following_relationships
  end

  def create
    user_to_follow = User.find(params[:id])
    current_user.follow(user_to_follow)
    redirect_to people_path
  end

  def destroy 
    relationship = Relationship.find(params[:id])
    relationship.destroy if relationship.follower == current_user
    redirect_to people_path
  end
end