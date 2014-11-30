require 'rails_helper'

describe CreditCard, :type => :model do
  it 'saves credit card expiration month and year' do
    cc = CreditCard.new
    cc.update_credit_card_expiration_date(2, 2020)
    
    expect(cc.expiration_month).to eq(2)
    expect(cc.expiration_year).to eq(2020)
  end
end
