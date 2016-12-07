require 'spec_helper'
require 'pry'

describe RelationshipsController do 
  describe 'GET index' do 
    it_behaves_like 'requires sign in' do 
      let(:action) { get :index}
    end

    it 'sets @following' do 
      andy = Fabricate(:user)
      bobby = Fabricate(:user)
      Fabricate(:relationship, followed_user: bobby, follower: andy)
      set_current_user(andy)
      get :index
      expect(assigns(:following)).to be_truthy
    end

    it 'sets @following to the people followed by the sign in use' do
      andy = Fabricate(:user)
      bobby = Fabricate(:user)
      Fabricate(:relationship, followed_user: bobby, follower: andy)
      set_current_user(andy)
      get :index
      expect(assigns(:following)).to eq([bobby])
    end
  end

  describe 'POST create' do

    it_behaves_like 'requires sign in' do 
      let(:action) { post :create, id: bobby.id }
    end

    it 'redirects to the people page' do
      andy = Fabricate(:user)
      set_current_user andy
      bobby = Fabricate(:user)
      binding.pry
      post :create, id: bobby.id
      expect(response).to redirect_to people_path
    end

    it 'creates a new relationship' do
      #andy = Fabricate(:user)
      #set_current_user andy
      #bobby = Fabricate(:user)
      binding.pry
      #post :create, id: bobby.id
      expect(Relationship.count).to eq(0)
    end

    it 'creates a relationship where the user is the follower' 

    it 'creates a relationships where the associated user is the followed_user'

    it 'does not permit a user to follow themselves'

    it 'does not permit the user to follow someone multiple times'

    it 'only creates relationshps in which the user is the follower'
  end
end