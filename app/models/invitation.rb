class Invitation < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :friend_email, :friend_name

  after_create :generate_token

  def generate_token
    token = SecureRandom.urlsafe_base64 
    self.update_attribute(:token, token)
  end
end