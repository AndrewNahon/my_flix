require 'spec_helper'

describe ReviewsController do 
  
  describe "POST create" do 
    
    it "redirects to the sign in path if the user is no signed in" do
      session[:user_id] = nil
      post :create, video_id: Fabricate(:video).id, review: Fabricate.attributes_for(:review)
      expect(response).to redirect_to sign_in_path
    end

    context "with valid inputs" do
      let(:andy) { Fabricate(:user) }
      let(:video) {Fabricate(:video) }
      before do
        set_current_user andy
        post :create, video_id: video.id, review: Fabricate.attributes_for(:review)
      end
      
      it "redirects to the show video page" do 
        expect(response).to redirect_to video_path(video)
      end

      it "creates a new review" do 
        expect(Review.count).to eq(1)
      end
      
      it "creates a review associated with the video" do 
        expect(Review.first.video).to eq(video)
      end
      
      it "creates a review associated with the signed in user" do
        expect(Review.first.user).to eq(andy)
      end
      
      it "displays a success msg" do 
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid inputs" do
      let(:video) { Fabricate(:video) }
      before do 
        set_current_user
        post :create, video_id: video.id, review: { rating: 5 }
      end
      
      it "sets @video" do 
        expect(assigns(:video)).to be_present
      end
      
      it "renders the show video template" do 
        expect(response).to render_template 'videos/show'
      end
      
      it "does not create the review" do 
        expect(Review.count).to eq(0)
      end
      
      it "displays an error msg" do 
        expect(flash[:danger]).to be_present
      end
    end
  end
end