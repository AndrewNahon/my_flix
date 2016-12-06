require 'spec_helper'

describe UsersController do 
  describe "GET new" do 
    it "sets @user" do 
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "POST create" do 
    context "with valid inputs" do 
      before { post :create, user: Fabricate.attributes_for(:user) }
      
      it "creates a new user" do 
        expect(User.count).to eq(1)
      end

      it "redirects to the sign in page" do 
        expect(response).to redirect_to sign_in_path
      end
      
      it "sets flash msg" do 
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid inputs" do
      before { post :create, user: { email: 'andy@example.com' } }

      it "does not create a new user" do 
        expect(User.count).to eq(0)
      end

      it "renders the register template" do 
        expect(response).to render_template :new
      end

      it "sets a flash danger msg" do 
        expect(flash[:danger]).to be_present
      end
    end
  end
end