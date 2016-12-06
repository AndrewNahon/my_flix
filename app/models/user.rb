class User < ActiveRecord::Base
  has_many :reviews
  has_many :queue_items, -> { order('position') }
  
  has_secure_password validations: false

  validates :email, presence: true, uniqueness: true
  validates :full_name, presence: true
  validates :password, presence: true

  def has_already_reviewed?(video)
    reviews.map(&:video_id).include?(video.id)
  end

  def normalize_queue_positions
    queue_items.each_with_index do |item, i| 
      item.update_attribute(:position, i + 1)
    end 
  end
end