shared_examples 'requires sign in' do 
  it "redirects to root path" do
    session[:user_id] = nil 
    action 
    expect(response).to redirect_to sign_in_path
  end
end