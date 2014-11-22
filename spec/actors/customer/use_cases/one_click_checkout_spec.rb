require 'rails_helper'

describe 'One Click Checkout' do
  it 'it delegates charging the customer for a given product to StripeGateway' do
    user = User.new(stripe_customer_id: 1)
    user.save(validate: false)
    product = Product.new(price: 20)
    product.save
    
    expect(StripeGateway).to receive(:charge)
    
    Actors::Customer::UseCases.one_click_checkout(user, product.id)
  end
end