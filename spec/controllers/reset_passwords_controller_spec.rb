require 'spec_helper' 

describe ResetPasswordsController do 
  describe 'GET new' do 
    it 'redirect to the invalid token page if the token is not valid' do 
      andy = Fabricate(:user, token: '12345')
      get :new, token: '54321'
      expect(response).to redirect_to invalid_token_path
    end

    it 'sets @token' do 
      andy = Fabricate(:user, token: '12345')
      get :new, token: '12345'
      expect(assigns(:token)).to eq('12345')
    end
    
    it 'renders the reset password page if the token is valid' do 
      andy = Fabricate(:user, token: '12345')
      get :new, token: '12345'
      expect(response).to render_template :new
    end
  end

  describe 'POST create' do 
    context 'with an valid token' do
      it 'resets the users password' do 
        andy = Fabricate(:user, token: '12345', password: 'password')
        post :create, token: '12345', password: 'new password'
        expect(User.first.authenticate('new password')).to be_truthy
      end
      
      it 'resets the users token to nil' do 
        andy = Fabricate(:user, token: '12345', password: 'password')
        post :create, token: '12345', password: 'new password'
        expect(andy.reload.token).to be_nil
      end

      it 'redirects to the sign in path' do 
        andy = Fabricate(:user, token: '12345', password: 'password')
        post :create, token: '12345', password: 'new password'
        expect(response).to redirect_to sign_in_path
      end
      
      it 'sets a flash msg' do 
        andy = Fabricate(:user, token: '12345', password: 'password')
        post :create, token: '12345', password: 'new password'
        expect(flash[:success]).to be_truthy
      end
    end

    context 'with invalid token' do 
      it 'redirects to the invalid token page' do 
        andy = Fabricate(:user)
        post :create, token: '12345', password: 'new password'
        expect(response).to redirect_to invalid_token_path
      end
    end
  end
end