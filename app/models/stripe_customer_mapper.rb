class StripeCustomerMapper
  def initialize(customer)
    @customer = customer
  end
  
  def credit_card_expiration_month
    @customer.sources.data[0].exp_month
  end
  
  def credit_card_expiration_year
    @customer.sources.data[0].exp_year
  end
  
  def credit_card_last4digits
    @customer.sources.data[0].last4
  end
end