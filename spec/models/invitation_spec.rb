require 'spec_helper'

describe Invitation do
  it { should belong_to :user }
  it { should validate_presence_of :friend_email }
  it { should validate_presence_of :friend_name }
  
  it 'generates token on creation' do 
    invitation = Fabricate(:invitation)
    expect(invitation.token).not_to be_nil
  end
end