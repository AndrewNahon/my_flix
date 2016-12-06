require 'spec_helper'

describe Video do 
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should have_many(:reviews).order('created_at DESC') }
  it { should belong_to :category }
  it { should have_many :queue_items }

  describe "search_by_title" do 
    it "returns an array containing a matching title for an exact match" do 
      video = Fabricate(:video, title: "The Godfather")
      results = Video.search_by_title("The Godfather")
      expect(results).to eq([video])
    end

    it "returns an array of one video for a partial match" do 
      video = Fabricate(:video, title: "The Godfather")
      results = Video.search_by_title("od")
      expect(results).to eq([video])
    end
    
    it "returns an array containing multiple matching titles" do 
      godfather1 = Fabricate(:video, title: "The Godfather")
      godfather2 = Fabricate(:video, title: "The Godfather II")
      godfather3 = Fabricate(:video, title: "The Godfather III")
      results = Video.search_by_title("Godfather")
      expect(results).to eq([godfather1, godfather2, godfather3])
    end
    
    it "returns an empty array if there are no matches" do 
      godfather1 = Fabricate(:video, title: "The Godfather")
      results = Video.search_by_title("Little Mermaid")
      expect(results).to eq([])
    end

    it "returns an empty array if the search term is blank" do 
      godfather1 = Fabricate(:video, title: "The Godfather")
      godfather2 = Fabricate(:video, title: "The Godfather II")
      godfather3 = Fabricate(:video, title: "The Godfather III")
      results = Video.search_by_title("")
      expect(results).to eq([])
    end

    it "returns an array of all matches ordered by created at" do 
      godfather1 = Fabricate(:video, title: "The Godfather" )
      godfather2 = Fabricate(:video, title: "The Godfather II", created_at: 1.days.ago )
      godfather3 = Fabricate(:video, title: "The Godfather III")
      results = Video.search_by_title("Godfather")
      expect(results).to eq([godfather2, godfather1, godfather3])
    end
  end

  describe '#rating' do 
    it "returns nil if the video has no reviews" do 
      video = Fabricate(:video)
      expect(video.rating).to be_nil
    end
    
    it "returns the reviews rating if there is one review" do 
      video = Fabricate(:video)
      review = Fabricate(:review, video: video)
      expect(video.rating).to eq(review.rating)
    end

    it "returns the average of multiple reviews" do 
      video = Fabricate(:video)
      Fabricate(:review, video: video, rating: 3, user: Fabricate(:user) )
      Fabricate(:review, video: video, rating: 5, user: Fabricate(:user) )
      expect(video.rating).to eq(4.0)
    end
  end

  describe '#already_in_queue?' do 
    
    it 'returns false if the video is not in the users queue' do 
      andy = Fabricate(:user)
      video = Fabricate(:video)
      expect(video.already_in_queue?(andy)).to be_falsey
    end
    
    it 'returns true if the video is in the users queue' do 
      andy = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, user: andy, video: video)
      expect(video.already_in_queue?(andy)).to be_truthy
    end
  end
end