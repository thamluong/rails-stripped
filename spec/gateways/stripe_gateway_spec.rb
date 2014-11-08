require 'stripe_mock'
require 'rails_helper'


describe StripeGateway do
  let(:stripe_helper) { StripeMock.create_test_helper }
  let(:plan) { stripe_helper.create_plan(:id => 'gold', :amount => 1500) }
  
  before { StripeMock.start }
  after { StripeMock.stop }
  
  it 'creates a stripe customer in our database' do
    sg = StripeGateway.new(Rails.logger)
    
    expect do
      subscription = sg.create_subscription('test-email', stripe_helper.generate_card_token, plan.id)
    end.to change{Subscription.count}.by(1)
  end

  it 'customer should be subscribed to gold plan' do
    sg = StripeGateway.new(Rails.logger)
    subscription = sg.create_subscription('test-email', stripe_helper.generate_card_token, plan.id)
    
    expect(subscription.plan_name).to eq('gold')
  end
  
end