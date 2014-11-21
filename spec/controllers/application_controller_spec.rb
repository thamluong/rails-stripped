require 'rails_helper'

describe ApplicationController, :type => :controller do

  it "GET index returns http success" do
    user = User.new
    user.save(validate: false)
    sign_in(user)
    
    expect(subject.current_or_guest_user.id).to eq(user.id)
  end
end