
class ReviewsController < ApplicationController
  before_filter :require_user

  def create
    @video = Video.find( params[:video_id] )
    review = @video.reviews.new(review_params.merge!(user: current_user))
    if review.save
      flash[:success] = 'Your review was created.'
      redirect_to video_path(@video)
    else
      flash[:danger] = current_user.has_already_reviewed?(@video) ? 'You can only review a video once.' : 'There was a problem with your inputs.'
      render 'videos/show'
    end
  end

  private 

  def review_params
    params.require(:review).permit(:rating, :body)
  end
end