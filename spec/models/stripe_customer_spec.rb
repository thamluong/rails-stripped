require 'rails_helper'

describe StripeCustomer do
  
  context 'save_subscription_details' do
    it 'should save stripe_customer_id' do  
      token = Stripe::Token.create(
                :card => {
                  :number => "4242424242424242",
                  :exp_month => 11,
                  :exp_year => 2025,
                  :cvc => "314"})
      customer = Stripe::Customer.create(card: token.id, description: "rspec-user@example.com")
      user = User.new(email: 'bogus@exmaple.com', password: '12345678')
      user.save

      StripeCustomer.save_subscription_details(user, customer, 'Gold')

      expect(user.stripe_customer_id).to eq(customer.id)
    end
    
    it 'should save credit card details' do  
      token = Stripe::Token.create(
                :card => {
                  :number => "4242424242424242",
                  :exp_month => 11,
                  :exp_year => 2025,
                  :cvc => "314"})
      customer = Stripe::Customer.create(card: token.id, description: "rspec-user@example.com")
      user = User.new(email: 'bogus@exmaple.com', password: '12345678')
      user.save

      StripeCustomer.save_subscription_details(user, customer, 'Gold')

      expect(user.credit_card.last4digits).to eq('4242')
      expect(user.credit_card.expiration_month).to eq(11)
      expect(user.credit_card.expiration_year).to eq(2025)
    end

    it 'should create subscription record' do  
      token = Stripe::Token.create(
                :card => {
                  :number => "4242424242424242",
                  :exp_month => 11,
                  :exp_year => 2025,
                  :cvc => "314"})
      customer = Stripe::Customer.create(card: token.id, description: "rspec-user@example.com")
      user = User.new(email: 'bogus@exmaple.com', password: '12345678')
      user.save

      StripeCustomer.save_subscription_details(user, customer, 'Gold')

      expect(user.subscription.plan_name).to eq('Gold')
      expect(user.subscription.stripe_customer_token).to eq(customer.id)
    end
  end    
    
end