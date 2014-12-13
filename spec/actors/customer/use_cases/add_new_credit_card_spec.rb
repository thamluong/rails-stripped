require 'rails_helper'

describe 'Add new credit card' do
  
  it 'should delegate add a new card to stripe gateway class' do
    VCR.use_cassette "add new credit card" do
      token = Stripe::Token.create(:card => {
                                      :number => "4242424242424242",
                                      :exp_month => 11,
                                      :exp_year => 2025,
                                      :cvc => "314"})
      customer = Stripe::Customer.create(card: token.id, description: "rspec-user@example.com")
      user = User.new(email: 'bogus@exmaple.com', password: '12345678', stripe_customer_id: customer.id)
      user.save!
      user.create_credit_card(last4digits: 1234)

      new_token = Stripe::Token.create(:card => {
                                         :number => "4012888888881881",
                                         :exp_month => 10,
                                         :exp_year => 2035,
                                         :cvc => "123"})

      card = Actors::Customer::UseCases.add_new_credit_card(user, new_token.id)
    
      expect(card.id).not_to be_nil
    end
  end

  it 'should save credit card last4digits, expiration month and year in our database' do
    VCR.use_cassette "add new credit card" do
      token = Stripe::Token.create(:card => {
                                      :number => "4242424242424242",
                                      :exp_month => 11,
                                      :exp_year => 2025,
                                      :cvc => "314"})
      customer = Stripe::Customer.create(card: token.id, description: "rspec-user@example.com")
      user = User.new(email: 'bogus@exmaple.com', password: '12345678', stripe_customer_id: customer.id)
      user.save!
      user.create_credit_card(last4digits: 1234)

      new_token = Stripe::Token.create(:card => {
                                         :number => "4012888888881881",
                                         :exp_month => 10,
                                         :exp_year => 2035,
                                         :cvc => "123"})

      card = Actors::Customer::UseCases.add_new_credit_card(user, new_token.id)
    
      expect(user.credit_card.last4digits).to eq('1881')
      expect(user.credit_card.expiration_month).to eq(10)
      expect(user.credit_card.expiration_year).to eq(2035)
    end
  end
  
end