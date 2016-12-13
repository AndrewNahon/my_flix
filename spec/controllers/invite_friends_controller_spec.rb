require 'spec_helper'

describe InvitedUsersController do 
  describe 'GET new' do 
    context 'with valid token' do 
      it 'sets @user.email to the invited friends email'
    end

    context 'with invalid token' do 
      it 'redirects to the invalid token path'
    end
  end
end