require 'rails_helper'

describe CreditCardsController, :type => :controller do
  it "initializes credit card variable" do
    User.create(email: 'bugs@disney.com', password: '12345678')
    user = User.last
    user.create_credit_card
    sign_in(user)   

    get :edit
    expect(assigns[:credit_card]).not_to be_nil
  end

  it "edit page returns http success if user is logged in" do
    User.create(email: 'bugs@disney.com', password: '12345678')
    user = User.last
    sign_in(user)   

    get :edit
    expect(response).to be_success
  end

  it "edit page returns http failure if user is not logged in" do      
    get :edit

    expect(response).not_to be_success
  end

  it "update returns http failure if user is not logged in" do
    get :update

    expect(response).not_to be_success
  end

  it 'delegates the update of credit card expiration to use case handler' do
    User.create(email: 'bugs@disney.com', password: '12345678')
    user = User.last
    user.create_credit_card
    sign_in(user)   

    expect(Actors::Customer::UseCases).to receive(:update_credit_card_expiration_date)

    get :update
  end
  
  it 'should initialize the user variable' do
    User.create(email: 'bugs@disney.com', password: '12345678')
    user = User.last
    user.create_credit_card
    sign_in(user)   

    allow(Actors::Customer::UseCases).to receive(:update_credit_card_expiration_date) { true }

    get :update
    
    expect(assigns[:user]).not_to be_nil
  end
  
end
