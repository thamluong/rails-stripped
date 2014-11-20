require 'rails_helper'
require 'stripe'

describe StripeGateway do
  it 'subscribe customer to gold plan' do
    # The fixture file is the Stripe response to a successful subscription to a gold plan
    h = JSON.parse(File.read("spec/support/fixtures/create_subscription_success.json"))
    customer = Stripe::Customer.construct_from(h)        
    allow(Stripe::Customer).to receive(:create) { customer }
    
    customer = StripeGateway.create_subscription('test-email', 'test-token', 'doesnot-matter')

    expect(customer.id).to eq('cus_5AqM5SPXDkx4Tl')
    expect(customer.subscriptions.data[0].plan.id).to eq('gold')
  end

  it 'should raise credit card exception when Stripe::InvalidRequestError occurs' do
    expect do
      customer = StripeGateway.create_subscription('fake', 'bogus', 'junk')
    end.to raise_error Striped::CreditCardException

  end

  it 'save customer credit card and charge' do
    h = JSON.parse(File.read("spec/support/fixtures/create_customer_success.json"))
    customer = Stripe::Customer.construct_from(h)        
    allow(Stripe::Customer).to receive(:create) { customer }
    allow(Stripe::Charge).to receive(:create) { true }
    
    customer = StripeGateway.save_credit_card_and_charge(2000, 1)
  
    expect(customer.id).to eq('cus_5AqFj04bLNXGYL')
  end
  
end