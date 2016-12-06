require 'spec_helper' 
require 'pry'

describe QueueItemsController do 
  
  describe 'GET index' do 
    it 'sets @queue_items to queue items of signed in user' do
      andy = Fabricate(:user)
      set_current_user(andy)
      video = Fabricate(:video)
      Fabricate(:queue_item, video: video, user: andy)
      get :index
      expect(assigns(:queue_items)).to eq(andy.queue_items)
    end

    it_behaves_like 'requires sign in' do
      let(:action) { get :index }
    end
  end

  describe 'POST create' do 
    it 'redirects to the my_queue page' do 
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to my_queue_path
    end
      
    it 'creates a queue item' do 
      andy = Fabricate(:user)
      set_current_user andy 
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end

    it "creates a queue item associated with the user and video" do 
      andy = Fabricate(:user)
      set_current_user andy 
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(andy)
      expect(QueueItem.first.video).to eq(video)
    end

    it 'sets the position to last in the queue' do 
      andy = Fabricate(:user)
      set_current_user(andy)
      video1 = Fabricate(:video)
      video2 = Fabricate(:video)
      Fabricate(:queue_item, position: 1, user: andy, video: video1)
      post :create, video_id: video2.id
      queue_item = QueueItem.find_by(video_id: video2.id)
      expect(queue_item.position).to eq(2)
    end
  end

  describe 'POST destroy' do 
    
    it 'redirects to the sign in path for unathenticate users' do
      queue_item = Fabricate(:queue_item)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to sign_in_path
    end
   
    it 'redirects to the my queue page for authenticated users' do 
      andy = Fabricate(:user)
      set_current_user(andy)
      queue_item = Fabricate(:queue_item)
      delete :destroy, id: queue_item.id 
      expect(response).to redirect_to my_queue_path
    end
    it 'deletes the associated queue item' do 
      andy = Fabricate(:user)
      set_current_user(andy)
      queue_item = Fabricate(:queue_item, user: andy)
      delete :destroy, id: queue_item.id
      expect(andy.reload.queue_items.count).to eq(0)
    end

    it 'only deletes the queue item if the item is in the users queue' do 
      andy = Fabricate(:user)
      set_current_user(andy)
      queue_item = Fabricate(:queue_item, user: Fabricate(:user))
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(1)
    end
    
    it 'updates the positions of remaining queue items' do
      andy = Fabricate(:user)
      set_current_user(andy)
      queue_item1 = Fabricate(:queue_item, user: andy, position: 1)
      queue_item2 = Fabricate(:queue_item, user: andy, position: 2)
      delete :destroy, id: queue_item1.id 
      expect(queue_item2.reload.position).to eq(1)
    end
  end

  describe 'POST update queue' do
    context 'with valid inputs' do
      it 'renders the my_queue page' do 
        andy = Fabricate(:user)
        set_current_user(andy)
        item1 = Fabricate(:queue_item, position: 1, user: andy)
        item2 = Fabricate(:queue_item, position: 2, user: andy)
        item3 = Fabricate(:queue_item, position: 3, user: andy)
        post :update_queue, queue_items: [ { id: item1.id, position: 3 },
                                           { id: item2.id, position: 1 },
                                           { id: item3.id, position: 1 } ]
        expect(response).to redirect_to my_queue_path
      end
      
      it 'assigns the new order to queue items' do 
        andy = Fabricate(:user)
        set_current_user(andy)
        item1 = Fabricate(:queue_item, position: 1, user: andy)
        item2 = Fabricate(:queue_item, position: 2, user: andy)
        item3 = Fabricate(:queue_item, position: 3, user: andy)
        post :update_queue, queue_items: [ { id: item1.id, position: 3 },
                                           { id: item2.id, position: 1 },
                                           { id: item3.id, position: 2 } ]
        expect(item1.reload.position).to eq(3)
        expect(item2.reload.position).to eq(1)
        expect(item3.reload.position).to eq(2)
      end
      
      it 'normalizes the position numbers' do
        andy = Fabricate(:user)
        set_current_user(andy)
        item1 = Fabricate(:queue_item, position: 1, user: andy)
        item2 = Fabricate(:queue_item, position: 2, user: andy)
        item3 = Fabricate(:queue_item, position: 3, user: andy)
        post :update_queue, queue_items: [ { id: item1.id, position: 100 },
                                           { id: item2.id, position: 2 },
                                           { id: item3.id, position: 40 } ]
        expect(andy.reload.queue_items.map(&:position)).to eq([1, 2, 3])
        
      end

      it 'changes the rating for the associated videos' do
        
      end
    end
    
    context 'with invalid inputs' do
      
      it 'does not change any of the queue item positions if a non-integer is submitted' do 
        andy = Fabricate(:user)
        set_current_user(andy)
        item1 = Fabricate(:queue_item, position: 1, user: andy)
        item2 = Fabricate(:queue_item, position: 2, user: andy)
        item3 = Fabricate(:queue_item, position: 3, user: andy)
        post :update_queue, queue_items: [ { id: item1.id, position: 3.5 },
                                           { id: item2.id, position: 2 },
                                           { id: item3.id, position: 40 } ]
        expect(item1.reload.position).to eq(1)
        expect(item2.reload.position).to eq(2)
        expect(item3.reload.position).to eq(3)
      end
      
      it 'redirects to the my queue page' do 
        andy = Fabricate(:user)
        set_current_user(andy)
        item1 = Fabricate(:queue_item, position: 1, user: andy)
        item2 = Fabricate(:queue_item, position: 2, user: andy)
        item3 = Fabricate(:queue_item, position: 3, user: andy)
        post :update_queue, queue_items: [ { id: item1.id, position: 3.5 },
                                           { id: item2.id, position: 2 },
                                           { id: item3.id, position: 40 } ]
        expect(response).to redirect_to my_queue_path
      end

      it 'changes the users rating for the associated video if a review exists' do 
        andy = Fabricate(:user)
        set_current_user(andy)
        video = Fabricate(:video)
        Fabricate(:review, user: andy, video: video, rating: 5)
        item = Fabricate(:queue_item, user: andy, video: video)
        post :update_queue, queue_items: [ { id: item.id, position: 2, rating: 1 } ]
        expect(Review.first.rating).to eq(1)
      end

      it 'creates a review with the rating if the review does not exist' do
        andy = Fabricate(:user)
        set_current_user(andy)
        video = Fabricate(:video)
        item = Fabricate(:queue_item, user: andy, video: video)
        post :update_queue, queue_items: [ { id: item.id, position: 2, rating: 1 } ]
        expect(Review.first.rating).to eq(1)
      end
    end
    
    context 'queue items not belonging to user' do 
      
      it 'does not modify queue items that do not belong to user' do
        andy = Fabricate(:user)
        set_current_user(andy)
        bobby = Fabricate(:user)
        item1 = Fabricate(:queue_item, position: 1, user: andy)
        item2 = Fabricate(:queue_item, position: 2, user: andy)
        item3 = Fabricate(:queue_item, position: 3, user: bobby)
        post :update_queue, queue_items: [ { id: item1.id, position: 3.5 },
                                           { id: item2.id, position: 2 },
                                           { id: item3.id, position: 1 } ]
        expect(item3.reload.position).to eq(3)
      end
    end
  end
end