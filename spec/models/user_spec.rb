require 'spec_helper'

describe User do
  it { should have_many :reviews }
  it { should have_many :queue_items }
  it { should validate_presence_of :full_name }
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of :email }
  it { should validate_presence_of :password }

  describe '#has_already_reviewed?(video' do 
    it 'returns false if the user has not reviewed a video' do 
      andy = Fabricate(:user)
      video = Fabricate(:video)
      expect(andy.has_already_reviewed?(video)).to be_falsy
    end
    
    it 'returns true if the user has reviewed the video' do
      andy = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:review, user: andy, video: video)
      expect(andy.reload.has_already_reviewed?(video)).to be_true
    end
  end

  describe '#normalize_queue_positions' do 
    it 'normalizes the position numbers in the users queue' do 
      andy = Fabricate(:user)
      Fabricate(:queue_item, user: andy, position: 1)
      Fabricate(:queue_item, user: andy, position: 10)
      Fabricate(:queue_item, user: andy, position: 20)
      Fabricate(:queue_item, user: andy, position: 30)
      andy.normalize_queue_positions
      expect(andy.reload.queue_items.map(&:position)).to eq([1, 2, 3, 4])
    end
  end

  describe '#following' do 
    it 'returns an array of users that follow the user' do 
      andy = Fabricate(:user) 
      bobby = Fabricate(:user)
      cindy = Fabricate(:user)
      dan = Fabricate(:user)
      Fabricate(:relationship, followed_user: bobby, follower: andy)
      Fabricate(:relationship, followed_user: cindy, follower: andy)
      Fabricate(:relationship, followed_user: dan, follower: andy)
      expect(andy.following).to include(bobby, cindy, dan)
    end

    it 'returns an empty array if user has no followers' do 
      andy = Fabricate(:user) 
      expect(andy.following).to eq([])
    end
  end

  describe '#can_follow?' do 
    
    it 'returns true if the user is a another user' do 
      andy = Fabricate(:user)
      bobby = Fabricate(:user)
      expect(andy.can_follow? bobby).to be_truthy
    end

    it 'returns false if the user is himself' do 
      andy = Fabricate(:user)
      expect(andy.can_follow?(andy)).to be_falsey
    end
    
    it 'returns false if the user is already following the user' do 
      andy = Fabricate(:user)
      bobby = Fabricate(:user)
      Fabricate(:relationship, followed_user: bobby, follower: andy)
      expect(andy.can_follow?(bobby)).to be_falsey
    end
  end

  describe '#follow' do 
    it 'creates a following relationship with another user' do 
      andy = Fabricate(:user)
      bobby = Fabricate(:user)
      andy.follow(bobby)
      expect(Relationship.first.follower_id).to eq(andy.id)
      expect(Relationship.first.followed_user_id).to eq(bobby.id)
    end
    
    it 'does not create the relationship with an invalid user' do 
      andy = Fabricate(:user)
      bobby = Fabricate(:user)
      andy.follow(andy)
      expect(Relationship.count).to eq(0)
    end
  end
end