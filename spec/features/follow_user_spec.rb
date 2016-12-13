require 'spec_helper'

feature 'follow other users' do
  scenario 'user interacts with following functionality' do
    andy = Fabricate(:user)
    bobby = Fabricate(:user)
    sign_in andy
    visit user_path(bobby)

    click_link 'Follow'

    expect(page).to have_content bobby.full_name

    visit user_path(bobby)

    expect(page).not_to have_content 'Follow'

    visit people_path 

    find("[data-method='delete']").click
    
    expect(page).not_to have_content bobby.full_name

  end
end