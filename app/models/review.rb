class Review < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  validates :rating, presence: true, inclusion: { in: [1, 2, 3, 4, 5] } 
  validates :body, presence: true, length: { minimum: 3 }
  validates_uniqueness_of :video_id, scope: :user_id
end