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
  
  it 'should save credit card expiration date' do
    u = User.create(email: 'bogus@exmaple.com', password: '12345678')
    u.create_credit_card(last4digits: '4321', expiration_month: 1, expiration_year: 2015)
    User.update_credit_card_expiration_date('1234', 2, 2020)
    
    user = User.last
    expect(user.credit_card.last4digits).to eq('1234')
    expect(user.credit_card.expiration_month).to eq(2)
    expect(user.credit_card.expiration_year).to eq(2020)
  end
end
