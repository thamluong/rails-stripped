require 'rails_helper'

describe SalesController, :type => :controller do

  it "returns http success" do
    get :new
    expect(response).to be_success
  end

  it 'should delegate guest checkout to use case handler' do 
    sign_in   
    expect(Actors::Customer::UseCases).to receive(:guest_checkout) { true }

    post :create, { stripeToken: '1', plan_name: 'gold'}
  end


end
