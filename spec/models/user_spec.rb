require 'rails_helper'

describe User, :type => :model do
  
  it 'should save stripe customer id' do
    u = User.new(email: 'bogus@exmaple.com', password: '12345678')
    
    u.save_stripe_customer_id('sk12')
    # can also do : u.reload.stripe_customer_id, but it's hackish.
    expect(User.last.stripe_customer_id).to eq('sk12')
  end

  it 'should return true if credit card token is present' do
    u = User.new(email: 'bogus@exmaple.com', password: '12345678', stripe_customer_id: 'sk10')

    expect(u.has_saved_credit_card?).to be(true)
  end

  it 'should return false if credit card token is present' do
    u = User.new(email: 'bogus@exmaple.com', password: '12345678')

    expect(u.has_saved_credit_card?).to be(false)
  end
    
end
