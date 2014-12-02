require 'rails_helper'

describe Order, :type => :model do
  it 'returns product name and amount for all orders' do
    p = Product.create(name: 'Rails 4 Quickly', price: 47) 
    u = User.new(email: 'test@example.com', password: '12345678')
    u.save
    u.payments.create(product_id: p.id, receipt_number: 'abc', amount: 47)
    
    orders = Order.all(u.payments)
    
    order = orders[0]
    expect(order[:product_name]).to eq(p.name)
    expect(order[:amount]).to eq(47.0)
  end
end
