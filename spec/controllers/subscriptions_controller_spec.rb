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

  it 'should handle credit card exception' do
    post :create, {stripeToken: 'bogus', plan_name: 'junk' }
    
    expect(assigns(:error_message)).to eq('Subscription failed. We have been notified about this problem.')
  end
  
  it 'should render the form when credit card exception occurs' do
    post :create, {stripeToken: 'bogus', plan_name: 'junk' }
    
    expect(response).to render_template(:new)
  end
  
  it 'should raise credit card exception when authentication error occurs' do
    Stripe.api_key = 'junk'

    post :create, {stripeToken: 'bogus', plan_name: 'junk' }
    
    expect(assigns(:error_message)).to eq('Subscription failed. We have been notified about this problem.')
  end
end



