require 'rails_helper'

describe 'Subscribe to a plan' do
  it 'creates subscription on Stripe server' do
    user = User.new(email: 'test')
    allow(StripeCustomer).to receive(:save_subscription_details)
    expect(StripeGateway).to receive(:create_subscription)
    
    Actors::Customer::UseCases.subscribe_to_a_plan(user, 1, 'gold')
  end
  
  it 'saves subscription details in our database' do
    user = User.new(email: 'test')
    expect(StripeCustomer).to receive(:save_subscription_details)
    allow(StripeGateway).to receive(:create_subscription)
    
    Actors::Customer::UseCases.subscribe_to_a_plan(user, 1, 'gold')    
  end
end