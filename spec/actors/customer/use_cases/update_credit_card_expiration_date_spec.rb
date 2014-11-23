require 'rails_helper'

describe 'Update credit card expiration date' do
  it 'it delegates update of credit card expiration to stripe gateway' do
    cc = double('Stripe Credit Card Response')
    allow(cc).to receive(:last4) { 1234 }
    allow(cc).to receive(:exp_month) { 10 }
    allow(cc).to receive(:exp_year) { 2050 }
    
    user = User.new(stripe_customer_id: 1)
    user.save(validate: false)

    allow(user).to receive(:save_credit_card_details) { true }
    expect(StripeGateway).to receive(:save_credit_card_details) { cc }
    
    Actors::Customer::UseCases.update_credit_card_expiration_date(user, 12, 2020)
  end
  
  it 'it saves credit card expiration date in our database' do
    cc = double('Stripe Credit Card Response')
    allow(cc).to receive(:last4) { 1234 }
    allow(cc).to receive(:exp_month) { 10 }
    allow(cc).to receive(:exp_year) { 2050 }
    
    user = User.new(stripe_customer_id: 1)
    user.save(validate: false)

    expect(user).to receive(:save_credit_card_details)
    allow(StripeGateway).to receive(:save_credit_card_details) { cc }
    
    Actors::Customer::UseCases.update_credit_card_expiration_date(user, 12, 2020)
  end
  
end