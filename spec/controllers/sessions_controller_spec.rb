require 'spec_helper'

describe SessionsController do 
  describe "GET new" do 
    it "redirects to the home page if user is signed in" do 
      session[:user_id] = Fabricate(:user).id 
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe "POST create" do 
    context "valid inputs" do
      let(:andy) { Fabricate(:user) }
      before { post :create, email: andy.email, password: andy.password } 
      
      it "sets the session user_id to the user ID" do 
        expect(session[:user_id]).to eq(andy.id)
      end
      
      it "displays a msg" do 
        expect(flash[:success]).to be_present
      end
      
      it "redirects to the home path" do 
        expect(response).to redirect_to home_path
      end
    end

    context "invalid inputs" do
      let(:andy) { Fabricate(:user, password: 'password') }
      before { post :create, email: andy.email, password: 'incorrect_password' } 
      
      it "does not set the session user_id" do 
        expect(session[:user_id]).to be_nil
      end

      it "display a msg" do 
        expect(flash[:danger]).to be_present
      end
      
      it "redirects to the sign in path" do 
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe "GET destroy" do
    context "the user is signed in" do
      before do 
        set_current_user
        get :destroy
      end 
      
      it "sets the session user_id to nil" do 
        expect(session[:user_id]).to be_nil
      end
      
      it "display a msg" do 
        expect(flash[:success]).to be_present
      end
      
      it "redirects to the sign in page" do
        expect(response).to redirect_to sign_in_path
      end
    end 
     
    context "the user is not signed in" do
      it "does not display a msg" do
        get :destroy 
        expect(flash[:success]).to_not be_present
      end
    end
  end

end

