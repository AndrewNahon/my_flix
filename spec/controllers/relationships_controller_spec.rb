require 'spec_helper'

describe RelationshipsController do 
  describe 'GET index' do 
    it_behaves_like 'requires sign in' do 
      let(:action) { get :index}
    end

    it 'sets @followed_user_relationships' do 
      andy = Fabricate(:user)
      bobby = Fabricate(:user)
      Fabricate(:relationship, followed_user: bobby, follower: andy)
      set_current_user(andy)
      get :index
      expect(assigns(:followed_user_relationships)).to be_truthy
    end
  end

  describe 'POST create' do

    it_behaves_like 'requires sign in' do 
      let(:action) { post :create, id: Fabricate(:user).id }
    end

    it 'redirects to the people page' do
      andy = Fabricate(:user)
      set_current_user andy
      bobby = Fabricate(:user)
      post :create, id: bobby.id
      expect(response).to redirect_to people_path
    end

    it 'creates a new relationship' do
      andy = Fabricate(:user)
      set_current_user andy
      bobby = Fabricate(:user)
      post :create, id: bobby.id
      expect(Relationship.count).to eq(1)
    end

    it 'creates a relationship where the user is the follower' do 
      andy = Fabricate(:user, full_name: "Andrew")
      set_current_user andy
      bobby = Fabricate(:user, full_name: "Bobby")
      post :create, id: bobby.id
      expect(andy.reload.following).to include(bobby)
    end

    it 'creates a relationships where the associated user is the followed_user' do 
      andy = Fabricate(:user, full_name: "Andrew")
      set_current_user andy
      bobby = Fabricate(:user, full_name: "Bobby")
      post :create, id: bobby.id
      expect(Relationship.first.followed_user).to eq(bobby)
    end

    it 'does not permit a user to follow themselves' do 
      andy = Fabricate(:user, full_name: "Andrew")
      set_current_user andy
      post :create, id: andy.id
      expect(Relationship.count).to eq(0)
    end

    it 'does not permit the user to follow someone multiple times' do 
      andy = Fabricate(:user)
      set_current_user andy 
      bobby = Fabricate(:user)
      Fabricate(:relationship, follower: andy, followed_user: bobby)
      post :create, id: bobby.id 
      expect(Relationship.count).to eq(1)
    end
  end

  describe 'POST destroy' do
    it 'destroys the associated relationship' do 
      andy = Fabricate(:user)
      set_current_user andy 
      relationship = Fabricate(:relationship, follower: andy, followed_user: Fabricate(:user))
      delete :destroy, id: relationship.id
      expect(andy.reload.following_relationships.count).to eq(0)

    end

    it 'destroys the associated relationship' do 
      andy = Fabricate(:user)
      set_current_user andy 
      relationship = Fabricate(:relationship, follower: andy, followed_user: Fabricate(:user))
      delete :destroy, id: relationship.id
      expect(response).to redirect_to people_path
    end

    it 'only destroys relationships in which the user is the follower' do 
      andy = Fabricate(:user)
      set_current_user andy 
      relationship = Fabricate(:relationship, follower: Fabricate(:user), followed_user: Fabricate(:user))
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(1)
    end
  end
end