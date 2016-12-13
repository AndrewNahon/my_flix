require 'spec_helper'
require 'pry'

describe UsersController do 
  describe "GET new" do 
    it "sets @user" do 
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "POST create" do 
    context "with valid inputs" do 
      before do
        post :create, user: Fabricate.attributes_for(:user)
      end 
      
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

    context "sending emails" do 
      before { ActionMailer::Base.deliveries.clear }
      
      it "sends out an email to a user with valid inputs" do 
        post :create, user: { full_name: 'Andrew', email: 'andrew@example.com', password: 'password' }
        expect(ActionMailer::Base.deliveries.last.to).to include 'andrew@example.com'
      end
      
      it "does not send an email when invalid inputs are submitted" do 
        post :create, user: { full_name: 'Andrew', password: 'password' }
        expect(ActionMailer::Base.deliveries).to be_empty
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

    context 'with invitation token' do 

      it 'creates following relationships between new user and inviter' do 
        andy = Fabricate(:user)
        invitation = Fabricate(:invitation, user: andy)
        invitation.update_attribute(:token, '12345')
        post :create, token: '12345', user: { full_name: 'Andrew', email: 'andrew@example.com', password: 'password' }
        expect(Relationship.count).to eq(2)
      end
      
      it 'does not creates relationships with an invalid token' do 
        andy = Fabricate(:user)
        invitation = Fabricate(:invitation, user: andy)
        post :create, token: '12345', user: { full_name: 'Andrew', email: 'andrew@example.com', password: 'password' }
        expect(Relationship.count).to eq(0)
      end
    end
  end
end