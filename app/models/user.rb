class User < ActiveRecord::Base
  has_many :reviews
  has_many :queue_items, -> { order('position') }
  has_many :following_relationships, class_name: 'Relationship', foreign_key: 'follower_id'
  has_many :followed_user_relationships, class_name: 'Relationship', foreign_key: 'followed_user_id'
  has_many :invitations
  
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

  def following 
    following_relationships.map(&:followed_user)
  end

  def can_follow?(a_user)
    !(following.include?(a_user) || a_user == self)
  end

  def generate_token
    token = SecureRandom.urlsafe_base64 
    self.update_attribute(:token, token)
  end

  def follow(a_user)
    Relationship.create(follower: self, followed_user: a_user) if self.can_follow?(a_user)
  end
end