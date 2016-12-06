require 'spec_helper'

feature 'my queue' do 
  scenario 'user adds a video to queue' do
    category = Fabricate(:category)
    video = Fabricate(:video, category: category)
    andy = Fabricate(:user)
    sign_in andy
    
    find_link("video_#{video.id}_link").click
    
    click_link '+ My Queue'
    
    expect(page).to have_content video.title

    visit "videos/#{video.id}"
    expect(page).to_not have_content '+ My Queue'
  end

  scenario 'user reorder video on queue' do
    category = Fabricate(:category)
    video1 = Fabricate(:video, title: 'die hard', category: category)
    video2 = Fabricate(:video, category: category)
    video3 = Fabricate(:video, category: category)
    andy = Fabricate(:user)
    sign_in andy

    add_to_queue video1 
    add_to_queue video2
    add_to_queue video3
    
    visit my_queue_path
    find("[data-video-id='#{video1.id}']").set(10)
    
    click_button "Update Instant Queue"
    
    visit my_queue_path 

    save_and_open_page
  end

  def add_to_queue(video)
    visit home_path
    find_link("video_#{video.id}_link").click
    click_link '+ My Queue'
    visit home_path
  end
end