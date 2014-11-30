require 'rails_helper'

describe ProductsController, :type => :controller do

  it "returns http success for show action" do
    get :show
  
    expect(response).to be_success
  end

  it "returns http success for download action" do
    User.create(email: 'bugs@disney.com', password: '12345678')
    user = User.last
    user.create_credit_card(last4digits: 1234)
    sign_in(user)   
    
    get :download
  
    expect(response).to be_success
  end

  it "returns http success for download action for guest user" do
    User.create(email: 'bugs@disney.com', password: '12345678')
    user = User.last
    user.create_credit_card(last4digits: 1234)
    
    get :download
  
    expect(response).to be_success
  end

  it "initializes credit card for download action" do
    User.create(email: 'bugs@disney.com', password: '12345678')
    user = User.last
    user.create_credit_card(last4digits: 1234)
    sign_in(user)   
    
    get :download
  
    expect(assigns[:credit_card].last4digits).to eq('1234')
  end
    
end
