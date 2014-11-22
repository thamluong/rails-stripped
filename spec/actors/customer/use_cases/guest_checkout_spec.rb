require 'rails_helper'

describe 'Guest Checkout' do
  it 'should save credit card at Stripe servers and charge the customer' do
    allow(Product).to receive(:price_in_cents_for) { 1000 }
    allow(StripeCustomer).to receive(:save_credit_card_and_stripe_customer_id) { true }
    expect(StripeGateway).to receive(:save_credit_card_and_charge)
    
    Actors::Customer::UseCases.guest_checkout(1, 'sk10', 'dummy user')
  end
  
  it 'should save customer details returned in Stripe response in our database' do
    allow(Product).to receive(:price_in_cents_for) { 1000 }
    allow(StripeGateway).to receive(:save_credit_card_and_charge) { true }
    expect(StripeCustomer).to receive(:save_credit_card_and_stripe_customer_id)
    
    Actors::Customer::UseCases.guest_checkout(1, 'sk10', 'dummy user')
  end
end