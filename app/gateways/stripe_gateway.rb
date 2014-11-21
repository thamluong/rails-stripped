class StripeGateway
  
  def self.create_subscription(email, stripe_token, plan_id)
    run_with_stripe_exception_handler('Create subscription failed due to') do
      Stripe::Customer.create(description: email, card: stripe_token, plan: plan_id)
    end    
  end
  # amount in cents
  def self.save_credit_card_and_charge(amount, stripe_token)
    run_with_stripe_exception_handler('StripeGateway.save_credit_card_and_charge failed due to') do
      # Create a Customer (save credit card)
      customer = Stripe::Customer.create(card: stripe_token, description: "guest-user@example.com")
      # Charge the Customer instead of the card. We discard the response, since no exception means success.
      Stripe::Charge.create(amount:   amount, 
                            currency: "usd",
                            customer: customer.id)
      customer
    end    
  end
  
  def self.charge(amount, customer_id)
    run_with_stripe_exception_handler('Could not charge customer due to') do
      Stripe::Charge.create(amount: amount, currency: "usd", customer: customer_id)
    end
  end
  
  
  def self.update_credit_card_expiration_date(stripe_customer_id, card_month, card_year)
    run_with_stripe_exception_handler("Failed to update credit card expiration date") do
      customer = Stripe::Customer.retrieve(stripe_customer_id)
      card = customer.cards.first
      card.exp_month = card_month
      card.exp_year = card_year
      card.save      
    end
  end
  
  private
  
  def self.run_with_stripe_exception_handler(message)
    begin
      yield
    rescue Stripe::CardError => e
      # Since it's a decline, Stripe::CardError will be caught
      body = e.json_body
      err  = body[:error]

      StripeLogger.error "Status is: #{e.http_status}"
      StripeLogger.error "Type is: #{err[:type]}"
      StripeLogger.error "Code is: #{err[:code]}"
      # param is '' in this case
      StripeLogger.error "Param is: #{err[:param]}"
      StripeLogger.error "Message is: #{err[:message]} :  #{e.backtrace.join("\n")}" 

      raise Striped::CreditCardDeclined.new(err[:message])     
    rescue Stripe::InvalidRequestError => e
      StripeLogger.error "#{message} Stripe::InvalidRequestError : #{e.message} :  #{e.backtrace.join("\n")}"
      
      raise Striped::CreditCardException.new(e.message)
    rescue Stripe::AuthenticationError => e
      StripeLogger.error "Authentication with Stripe's API failed :  #{e.backtrace.join("\n")}"
      StripeLogger.error "(maybe you changed API keys recently)"
      
      raise Striped::CreditCardException.new(e.message)
    rescue Stripe::APIConnectionError => e
      StripeLogger.error "Network communication with Stripe failed :  #{e.backtrace.join("\n")}"
    
      raise Striped::CreditCardException.new(e.message)
    rescue Stripe::StripeError => e
      StripeLogger.error "Display a very generic error to the user, and maybe send yourself an email :  #{e.backtrace.join("\n")}"
      
      raise Striped::CreditCardException.new(e.message)
    rescue Exception => e
      StripeLogger.error "#{message} : #{e.message} :  #{e.backtrace.join("\n")}"  
      
      raise
    end
  end
end