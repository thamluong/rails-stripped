class StripeCustomerMapper
  def initialize(customer)
    @customer = customer
  end
  
  def credit_card_expiration_month
    @customer.cards.data[0].exp_month
  end
  
  def credit_card_expiration_year
    @customer.cards.data[0].exp_year
  end
  
  def credit_card_last4digits
    @customer.cards.data[0].last4
  end
end