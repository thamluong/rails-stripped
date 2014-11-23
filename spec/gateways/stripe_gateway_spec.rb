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
  
  it 'update credit card expiration date' do
    h = JSON.parse(File.read("spec/support/fixtures/customer.json"))
    customer = Stripe::Customer.construct_from(h)        
    allow(Stripe::Customer).to receive(:retrieve) { customer }
    
    h2 = JSON.parse(File.read("spec/support/fixtures/credit_card.json"))
    cc = Stripe::Card.construct_from(h2)
    allow(customer).to receive_message_chain(:cards, :first) { cc }
    
    credit_card = StripeGateway.save_credit_card_details(1, 1, 2050)
    
    expect(credit_card.id).to eq('card_150UekKmUHg13gkFdTz9kRjI')
  end
  
  it 'adds a new credit card as the active default card on Stripe server' do
    token = Stripe::Token.create(:card => {
                                   :number    => "4242424242424242",
                                   :exp_month => 11,
                                   :exp_year  => 2025,
                                   :cvc       => "314"})
        
    customer = Stripe::Customer.create(:card => token.id, :description => "stripe-gateway-test@example.com")

    new_token = Stripe::Token.create(:card => {
                                       :number => "4012888888881881",
                                       :exp_month => 10,
                                       :exp_year => 2035,
                                       :cvc => "123"})
    
    card = StripeGateway.add_new_credit_card(customer.id, new_token.id)
    expect(card).to be_instance_of(Stripe::Card)
  end
end