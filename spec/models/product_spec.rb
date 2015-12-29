require 'rails_helper'

describe Product, :type => :model do
  
  before do
    Product.destroy_all
    Product.create(name: "Get Rich Quick", price: 10)
  end
  
  it 'should return price in cents for a given product' do  
    product = Product.first
    
    price_in_cents = Product.price_in_cents_for(product.id)
    
    expect(price_in_cents).to eq(1000)
  end
end
