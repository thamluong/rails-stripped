require 'stripe_mock'
require 'rails_helper'
require 'stripe'

describe StripeGateway do
  context 'success scenario' do
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

  it 'should raise credit card exception when Stripe::InvalidRequestError occurs' do
    sg = StripeGateway.new(Rails.logger)

    expect do
      customer = sg.create_subscription('fake', 'bogus', 'junk')
    end.to raise_error Striped::CreditCardException

  end
  
end