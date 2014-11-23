require 'rails_helper'

describe CreditCard, :type => :model do
  it 'saves credit card details' do
    cc = CreditCard.new
    cc.save_credit_card_details('1234', 2, 2020)
    
    expect(cc.last4digits).to eq('1234')
    expect(cc.expiration_month).to eq(2)
    expect(cc.expiration_year).to eq(2020)
  end
end
