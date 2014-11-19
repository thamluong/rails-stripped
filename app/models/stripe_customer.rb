class StripeCustomer
  
  def self.save(customer, user)
    last4digits = customer.cards.data[0].last4
    expiration_month = customer.cards.data[0].exp_month
    expiration_year = customer.cards.data[0].exp_year
    
    user.save_stripe_customer_id(customer.id)
    user.create_credit_card(last4digits: last4digits, 
                            expiration_month: expiration_month, 
                            expiration_year: expiration_year)
  end
  
  def self.transfer_guest_user_values_to_registered_user(guest_user, current_user)
    current_user.save_stripe_customer_id(guest_user.stripe_customer_id)
    credit_card = guest_user.credit_card
    credit_card.user_id = current_user.id
    credit_card.save!
  end
end