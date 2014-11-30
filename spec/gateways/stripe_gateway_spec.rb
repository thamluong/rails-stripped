require 'rails_helper'
require 'stripe'

describe StripeGateway do
  it 'subscribe customer to gold plan' do                              
    token = Stripe::Token.create(:card => {
                                    :number => "4242424242424242",
                                    :exp_month => 11,
                                    :exp_year => 2025,
                                    :cvc => "314"})
    
    customer = StripeGateway.create_subscription('bogus-email', token.id, 'gold')
  
    expect(customer.id).not_to be_nil
  end
  
  it 'should raise credit card exception when Stripe::InvalidRequestError occurs' do
    expect do
      customer = StripeGateway.create_subscription('fake', 'bogus', 'junk')
    end.to raise_error Striped::CreditCardException
  end
  
  it 'saves customer credit card on Stripe servers' do
    token = Stripe::Token.create(:card => {
                                    :number => "4242424242424242",
                                    :exp_month => 11,
                                    :exp_year => 2025,
                                    :cvc => "314"})  

    customer = StripeGateway.save_credit_card(token.id)
  
    expect(customer.id).not_to be_nil
  end

  it 'update credit card expiration date' do
    token = Stripe::Token.create(:card => {
                                    :number => "4242424242424242",
                                    :exp_month => 11,
                                    :exp_year => 2025,
                                    :cvc => "314"})  
    customer = Stripe::Customer.create(card: token.id, description: "rspec-user@example.com")
    
    card = StripeGateway.update_credit_card_expiration_date(customer.id, 10, 2024)
    
    expect(card.exp_month).to eq(10)
    expect(card.exp_year).to eq(2024)
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