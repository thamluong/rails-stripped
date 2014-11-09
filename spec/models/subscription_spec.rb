require 'rails_helper'

describe Subscription do
  it 'should display plan name in human readable form' do
    subscription = Subscription.new(plan_name: 'gold')
    
    expect(subscription.plan_display_name).to eq('Gold')
  end
  
  it 'subscription is not complete when the customer is not in stripe system' do
    subscription = Subscription.new
    
    expect(subscription).not_to be_complete
  end

  it 'subscription is complete when the customer is in the strip system' do
    subscription = Subscription.new(stripe_customer_token: 1)
    
    expect(subscription).to be_complete
  end  
  
  it 'should save customer subscription details' do
    subscription = Subscription.new
    subscription.save_details('1', 'gold')
    
    expect(subscription.stripe_customer_token).to eq('1')
    expect(subscription.plan_name).to eq('gold')
  end
end