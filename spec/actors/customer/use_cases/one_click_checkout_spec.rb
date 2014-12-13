require 'rails_helper'

describe 'One Click Checkout' do
    
  it 'it creates payment after charging the customer for a product' do
    VCR.use_cassette "one click checkout" do
      token = Stripe::Token.create(
                :card => {
                  :number => "4242424242424242",
                  :exp_month => 11,
                  :exp_year => 2025,
                  :cvc => "314"})
      customer = Stripe::Customer.create(card: token.id, description: "rspec-user@example.com")
      user = User.new(email: 'bogus@exmaple.com', password: '12345678', stripe_customer_id: customer.id)
      user.save
      product = Product.new(name: 'Rails 4 Quickly', price: 47)  
      product.save
    
      Actors::Customer::UseCases.one_click_checkout(user, product.id)
    
      payment = Payment.last
      expect(payment.product_id).to eq(product.id)
      expect(payment.amount).to eq(product.price)
      expect(payment.user_id).to eq(user.id)  
    end
  end
end