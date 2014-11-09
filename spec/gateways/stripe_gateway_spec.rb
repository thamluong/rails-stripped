require 'stripe_mock'
require 'rails_helper'


describe StripeGateway do
  let(:stripe_helper) { StripeMock.create_test_helper }
  let(:plan) { stripe_helper.create_plan(:id => 'gold', :amount => 1500) }
  
  before { StripeMock.start }
  after { StripeMock.stop }
  
  it 'customer should be subscribed to gold plan' do
    sg = StripeGateway.new(Rails.logger)
    customer = sg.create_subscription('test-email', stripe_helper.generate_card_token, plan.id)
    
    expect(customer.id).to eq('test_cus_3')
  end
  
end