require 'rails_helper'

describe StripeCustomerMapper do
  
  it 'should map credit card expiration month' do
    h = JSON.parse(File.read("spec/support/fixtures/create_customer_success.json"))
    customer = Stripe::Customer.construct_from(h)    
    
    mapper = StripeCustomerMapper.new(customer)
    
    expect(mapper.credit_card_expiration_month).to eq(9)
  end
  
  it 'should map credit card expiration year' do
    h = JSON.parse(File.read("spec/support/fixtures/create_customer_success.json"))
    customer = Stripe::Customer.construct_from(h)    
    
    mapper = StripeCustomerMapper.new(customer)
    
    expect(mapper.credit_card_expiration_year).to eq(2020)
  end

  it 'should map credit card last 4 digits' do
    h = JSON.parse(File.read("spec/support/fixtures/create_customer_success.json"))
    customer = Stripe::Customer.construct_from(h)    
    
    mapper = StripeCustomerMapper.new(customer)
    
    expect(mapper.credit_card_last4digits).to eq('4242')
  end

end