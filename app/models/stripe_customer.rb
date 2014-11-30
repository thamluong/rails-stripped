class StripeCustomer
  
  # Use Case : Add New Credit Card
  def self.save_credit_card_details(card, user)
    user.create_credit_card(last4digits: card.last4, expiration_month: card.exp_month, expiration_year: card.exp_year)
  end
  
  # Use Case : Subscribe to a plan
  def self.save_subscription_details(user, customer, plan_name)
    user.create_subscription(stripe_customer_token: customer.id, plan_name: plan_name)    
    save_credit_card_and_stripe_customer_id(customer, user)    
  end
  
  # Use Case : Guest Checkout
  # Saves the stripe response values in our database
  def self.save_credit_card_and_stripe_customer_id(customer, user)
    mapper = StripeCustomerMapper.new(customer)
    user.email = User.generate_random_guest_email
        
    user.save_stripe_customer_id(customer.id)
    user.create_credit_card(last4digits:      mapper.credit_card_last4digits, 
                            expiration_month: mapper.credit_card_expiration_month, 
                            expiration_year:  mapper.credit_card_expiration_year)
  end
  
  def self.create_payment(product_id, user_id, charge_id)
    product = Product.find(product_id)
    Payment.create(product_id: product_id, user_id: user_id, amount: product.price, receipt_number: charge_id)
  end
    
end