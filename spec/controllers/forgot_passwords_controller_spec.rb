require 'spec_helper'

describe ForgotPasswordsController do 
  describe 'POST create' do 

    it 'redirect to the sign in page' do
      andy = Fabricate(:user)
      set_current_user andy
      post :create, email: andy.email
      expect(response).to redirect_to forgot_password_path
    end
    
    it 'creates a token for the user with the associated email' do 
      andy = Fabricate(:user)
      set_current_user andy
      post :create, email: andy.email
      expect(andy.reload.token).not_to be_nil
    end
    
    it 'sends an email to the associated user with a link to reset password page' do 
       andy = Fabricate(:user)
       set_current_user andy
       post :create, email: andy.email
       expect(ActionMailer::Base.deliveries.last.to).to eq([andy.email])
    end
    
    context 'the email is not registered' do 
      it 'redirects to the forgot password page' do 
        andy = Fabricate(:user)
        set_current_user andy
        post :create, email: andy.email
        expect(response).to redirect_to forgot_password_path
      end
      it 'displays a msg' do 
        andy = Fabricate(:user)
        set_current_user andy
        post :create, email: 'noemail@example.com'
        expect(flash[:danger]).to be_present
      end
    end

    context 'the email entered is an empty string' do 
      it 'renders the forgot password page' do 
        andy = Fabricate(:user)
        set_current_user andy
        post :create, email: ''
        expect(response).to redirect_to forgot_password_path
      end
      it 'displays a msg' do 
        andy = Fabricate(:user)
        set_current_user andy
        post :create, email: 'noemail@example.com'
        expect(flash[:danger]).to be_present
      end
    end
  end
end