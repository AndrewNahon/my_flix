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
end