class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order('created_at DESC') }
  has_many :queue_items

  validates :title, presence: true
  validates :description, presence: true

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    Video.where("title LIKE ?", "%#{search_term}%").order('created_at ASC')
  end

  def rating 
    return nil if reviews.empty?
    (reviews.map(&:rating).reduce(:+).to_f / reviews.size).round(1)
  end

  def already_in_queue?(user)
    user.queue_items.map(&:video_id).include?(id)
  end
end