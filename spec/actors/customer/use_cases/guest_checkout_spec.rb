require 'rails_helper'

describe 'Guest Checkout' do
  before(:each) do
    Product.create(name: 'Rails 4 Quickly', price: 47)  
  end
  
  it 'should save credit card at Stripe servers and save credit_card details in our database' do
    product = Product.first
    token = Stripe::Token.create(:card => {
                                    :number => "4242424242424242",
                                    :exp_month => 11,
                                    :exp_year => 2025,
                                    :cvc => "314"})
    user = User.new(email: 'bogus@exmaple.com', password: '12345678')
    user.save
    
    Actors::Customer::UseCases.guest_checkout(product.id, token.id, user)
    
    expect(User.last.credit_card.last4digits).to eq('4242')
    expect(User.last.credit_card.expiration_month).to eq(11)
    expect(User.last.credit_card.expiration_year).to eq(2025)
  end

  it 'should create payment record in our database' do
    product = Product.first
    token = Stripe::Token.create(:card => {
                                    :number => "4242424242424242",
                                    :exp_month => 11,
                                    :exp_year => 2025,
                                    :cvc => "314"})
    user = User.new(email: 'bogus@exmaple.com', password: '12345678')
    user.save
    
    Actors::Customer::UseCases.guest_checkout(product.id, token.id, user)

    payment = Payment.last
    expect(payment.product_id).to eq(product.id)
    expect(payment.amount).to eq(product.price)
    expect(payment.user_id).to eq(user.id)
  end

  it 'should save stripe_customer_id in our database' do
    product = Product.first
    token = Stripe::Token.create(:card => {
                                    :number => "4242424242424242",
                                    :exp_month => 11,
                                    :exp_year => 2025,
                                    :cvc => "314"})
    user = User.new(email: 'bogus@exmaple.com', password: '12345678')
    user.save
    
    Actors::Customer::UseCases.guest_checkout(product.id, token.id, user)

    user = User.last
    expect(user.stripe_customer_id).not_to be_nil
  end
end