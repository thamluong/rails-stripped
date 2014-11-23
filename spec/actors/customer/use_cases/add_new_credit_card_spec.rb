require 'rails_helper'

describe 'Add new credit card' do
  
  it 'should delegate add a new card to stripe gateway class' do
    user = double('User')
    allow(user).to receive(:stripe_customer_id) { 1 }
    allow(StripeCustomer).to receive(:save_credit_card_details)

    expect(StripeGateway).to receive(:add_new_credit_card)

    Actors::Customer::UseCases.add_new_credit_card(user, 'stripe-token')
  end

  it 'should delegate saving credit card details to stripe customer class' do
    user = double('User')
    allow(user).to receive(:stripe_customer_id) { 1 }
    allow(StripeGateway).to receive(:add_new_credit_card)

    expect(StripeCustomer).to receive(:save_credit_card_details)
    
    Actors::Customer::UseCases.add_new_credit_card(user, 'stripe-token')
  end
  
end