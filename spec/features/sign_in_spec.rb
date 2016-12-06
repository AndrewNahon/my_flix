require 'spec_helper' 

feature 'user signs in' do 
  scenario 'a registered user signs in' do
    andy = Fabricate(:user) 
    sign_in andy
    expect(page).to have_content andy.full_name
  end
end