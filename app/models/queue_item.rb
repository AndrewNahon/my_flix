class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates :position, numericality: { only_integer: true, greater_than: 0 }

  delegate :title, to: :video, prefix: :video
  delegate :category, to: :video

  def category_name
    category.name
  end

  def rating 
    review = Review.find_by(user: user, video: video)
    review.rating if review
  end

  def rating=(new_rating)
    review = Review.find_by(user: user, video: video)
    if review 
      review.update_attribute(:rating, new_rating)
    else
      Review.new(video: video, user: user, rating: new_rating).save(validate: false)
    end
  end
end