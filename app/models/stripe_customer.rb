class StripeCustomer
  
  # Use Case : Add New Credit Card
  def self.save_credit_card_details(card, user)
    user.save_credit_card_details(card.last4, card.exp_month, card.exp_year)
  end
  
  # Use Case : Subscribe to a plan
  def self.save_subscription_details(user, customer, plan_name)
    user.create_subscription(stripe_customer_token: customer.id, plan_name: plan_name)    
    save_credit_card_and_stripe_customer_id(customer, user)    
  end
  
  # Use Case : Guest Checkout
  # Save the stripe response values in our database
  def self.save_credit_card_and_stripe_customer_id(customer, user)
    last4digits = customer.cards.data[0].last4
    expiration_month = customer.cards.data[0].exp_month
    expiration_year = customer.cards.data[0].exp_year
    user.email = "guest_#{Time.now.to_i}#{rand(100)}@example.com"
        
    user.save_stripe_customer_id(customer.id)
    user.create_credit_card(last4digits: last4digits, 
                            expiration_month: expiration_month, 
                            expiration_year: expiration_year)
  end
    
end