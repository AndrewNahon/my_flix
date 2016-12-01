require 'spec_helper'

describe Category do 
  it { should have_many(:videos).order('created_at DESC') }

  describe "#recent_videos" do 
    it "returns six videos" do 
      category = Fabricate(:category)
      10.times { Fabricate(:video, category: category) }
      expect(category.recent_videos.count).to eq(6)
    end
    
    it "returns the videos in reverse chronological order" do 
      category = Fabricate(:category)
      6.times { Fabricate(:video, category: category, created_at: 1.days.ago) }
      new_video = Fabricate(:video, category: category)
      expect(category.recent_videos.first).to eq(new_video)
    end
    
    it "all the videos if there are less than six videos" do 
      category = Fabricate(:category)
      3.times { Fabricate(:video, category: category) }
      expect(category.recent_videos.count).to eq(3)
    end

    it "returns an empty array if the category has no videos" do 
      category = Fabricate(:category)
      expect(category.recent_videos).to eq([])
    end
  end
end