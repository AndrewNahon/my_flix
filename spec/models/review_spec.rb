require 'spec_helper' 

describe Review do 
  it { should belong_to :user }
  it { should belong_to(:video) }
  it { should validate_presence_of :body }
  it { should validate_presence_of :rating }
  it { should validate_uniqueness_of(:video_id).scoped_to(:user_id) }
end