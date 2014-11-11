require 'rails_helper'

describe SubscriptionsController do
  
  it 'should delegate creating stripe customer to stripe gateway' do    
    allow(Actors::Customer::UseCases).to receive(:subscribe_to_a_plan).with('current_user.email', '1', 'gold', Rails.logger)

    post :create, { stripeToken: '1', plan_name: 'gold'}
  end
  
  it 'should initialize plan name' do
    get :new, {plan_name: 'gold'}
    
    expect(assigns(:plan_name)).to eq('gold')
  end

  
end



