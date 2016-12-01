require 'spec_helper'

describe Video do 
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should belong_to :category }

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
end