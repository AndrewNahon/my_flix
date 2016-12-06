require 'spec_helper'

describe QueueItem do
  it { should belong_to :user }
  it { should belong_to :video }

  describe '#video_title' do 
    it 'should return the title of the associated video' do 
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq(video.title)
    end
  end

  describe '#video_rating' do 
    it 'returns nil if the associated video has no review' do 
      video = Fabricate(:video)
      Fabricate(:queue_item, video: video)
      expect(QueueItem.first.rating).to be_nil
    end

    it 'returns the videos associated rating' do
      video = Fabricate(:video)
      Fabricate(:review, video: video, rating: 5)
      Fabricate(:queue_item, video: video)
      expect(QueueItem.first.rating).to eq(5)
    end
  end

  describe '#rating=' do
    
    it 'updates the rating for the associated video if a review exists' do 
      video = Fabricate(:video)
      Fabricate(:review, video: video, rating: 5)
      item = Fabricate(:queue_item, video: video)
      item.rating = 1
      expect(QueueItem.first.rating).to eq(1)

    end
    
    it 'creates a review with the new rating if a review does not exist' do
      video = Fabricate(:video)
      item = Fabricate(:queue_item, video: video)
      item.rating = 5
      expect(Review.first.rating).to eq(5) 
    end
  end
end