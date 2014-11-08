require 'rails_helper'

describe SubscriptionsController do
  
  it 'should delegate creating stripe customer and subscription record to stripe gateway' do
    stripe_gateway = instance_double('StripeGateway')    
    allow(StripeGateway).to receive_messages(:new => stripe_gateway)
    allow(stripe_gateway).to receive(:create_subscription).with('current_user.email', '1', 'gold')

    post :create, { stripeToken: '1', plan_name: 'gold'}
  end
  
  it 'should initialize plan name' do
    get :new, {plan_name: 'gold'}
    
    expect(assigns(:plan_name)).to eq('gold')
  end
end