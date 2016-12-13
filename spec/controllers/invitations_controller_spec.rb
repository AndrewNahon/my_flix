require 'spec_helper'

describe InvitationsController do 
  describe 'GET new' do 
    
    it_behaves_like 'requires sign in' do 
      let(:action) { get :new }
    end
    
    it 'sets @invitation' do 
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_instance_of(Invitation)
    end
  end

  describe 'POST create' do 
    it_behaves_like 'requires sign in' do 
      let(:action) { post :create}
    end

    context 'with valid inputs' do
      let(:andy) { Fabricate(:user) }
      before { set_current_user andy }
      
      it 'creates a new invitation' do 
        post :create, friend_email: 'bobby@example.com', friend_name: 'Bobby', message: 'Join this great app!'
        expect(Invitation.count).to eq(1)
      end

      it 'sends an invitation email to friend' do 
        post :create, friend_email: 'bobby@example.com', friend_name: 'Bobby', message: 'Join this great app!'
        expect(ActionMailer::Base.deliveries.last.to).to eq(['bobby@example.com'])
      end
      
      it 'redirects to invite friend page' do 
        post :create, friend_email: 'bobby@example.com', friend_name: 'Bobby', message: 'Join this great app!'
        expect(response).to redirect_to invite_friend_path
      end
      
      it 'sets a success msg' do 
        post :create, friend_email: 'bobby@example.com', friend_name: 'Bobby', message: 'Join this great app!'
        expect(flash[:success]).to be_present
      end
    end

    context 'with invalid inputs' do 
      let(:andy) { Fabricate(:user) }
      before { set_current_user andy }

      it 'does not create an invitation' do 
        post :create, friend_name: 'Bobby', message: 'Join this great app!'
        expect(Invitation.count).to eq(0)
      end
      
      it 'redirects to the invite friend page' do 
        post :create, friend_name: 'Bobby', message: 'Join this great app!'
        expect(response).to redirect_to invite_friend_path
      end
      
      it 'displays an error msg' do
        post :create, friend_name: 'Bobby', message: 'Join this great app!'
        expect(flash[:danger]).to be_present
      end
    end
  end
end