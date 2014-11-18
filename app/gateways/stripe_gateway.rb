class StripeGateway
  
  def self.create_subscription(email, stripe_token, plan_id)
    begin
      customer = Stripe::Customer.create(description: email, card: stripe_token, plan: plan_id)
    rescue Stripe::CardError => e
      # Since it's a decline, Stripe::CardError will be caught
      body = e.json_body
      err  = body[:error]

      StripeLogger.error "Status is: #{e.http_status}"
      StripeLogger.error "Type is: #{err[:type]}"
      StripeLogger.error "Code is: #{err[:code]}"
      # param is '' in this case
      StripeLogger.error "Param is: #{err[:param]}"
      StripeLogger.error "Message is: #{err[:message]}" 

      raise Striped::CreditCardDeclined.new(err[:message])     
    rescue Stripe::InvalidRequestError => e
      StripeLogger.error "Create subscription failed due to Stripe::InvalidRequestError : #{e.message}"
      
      raise Striped::CreditCardException.new(e.message)
    rescue Stripe::AuthenticationError => e
      StripeLogger.error "Authentication with Stripe's API failed"
      StripeLogger.error "(maybe you changed API keys recently)"
      
      raise Striped::CreditCardException.new(e.message)
    rescue Stripe::APIConnectionError => e
      StripeLogger.error "Network communication with Stripe failed"
    
      raise Striped::CreditCardException.new(e.message)
    rescue Stripe::StripeError => e
      StripeLogger.error "Display a very generic error to the user, and maybe send yourself an email"
      
      raise Striped::CreditCardException.new(e.message)
    rescue Exception => ex
      StripeLogger.error "Create subscription failed due to : #{ex.message}"  
      
      raise
    end
  end
  # amount in cents
  def self.save_credit_card_and_charge(amount, stripe_token)
    begin
      # Create a Customer
      customer = Stripe::Customer.create(card: stripe_token, description: "guest-user@example.com")
      # Charge the Customer instead of the card
      Stripe::Charge.create(amount:   amount, 
                            currency: "usd",
                            customer: customer.id)
      customer.id
    rescue Stripe::CardError => e
      # Since it's a decline, Stripe::CardError will be caught
      body = e.json_body
      err  = body[:error]
    
      StripeLogger.error "Status is: #{e.http_status}"
      StripeLogger.error "Type is: #{err[:type]}"
      StripeLogger.error "Code is: #{err[:code]}"
      # param is '' in this case
      StripeLogger.error "Param is: #{err[:param]}"
      StripeLogger.error "Message is: #{err[:message]}" 
    
      raise Striped::CreditCardDeclined.new(err[:message])     
    rescue Exception => ex
      StripeLogger.error "Purchase failed due to : #{ex.message}"  
      
      raise
    end
  end
  
  def self.charge(amount, customer_id)
    begin
      Stripe::Charge.create(amount: amount, currency: "usd", customer: customer_id)
    rescue Exception => e
      StripeLogger.error "Could not charge customer due to : #{e.message},  #{e.backtrace.join("\n")}"
      
      raise      
    end
  end
  
end