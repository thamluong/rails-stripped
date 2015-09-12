class StripeGateway
  
  def self.add_new_credit_card(stripe_customer_id, stripe_token)
    run_with_stripe_exception_handler('Add a new credit card failed due to') do
      Filly::CreditCard.add(stripe_customer_id, stripe_token)      
    end
  end
  
  def self.create_subscription(email, stripe_token, plan_id)
    run_with_stripe_exception_handler('Create subscription failed due to') do
      Colt::Subscription.create(email, stripe_token, plan_id, 'none')
    end    
  end

  def self.save_credit_card(stripe_token)
    run_with_stripe_exception_handler('StripeGateway.save_credit_card failed due to') do
      Filly::CreditCard.save(stripe_token, "guest-user@example.com")
    end    
  end
  
  # amount in cents  
  def self.charge(amount, customer_id)
    run_with_stripe_exception_handler('Could not charge customer due to') do
      Chivas::CreditCard.charge(amount, customer_id)
    end
  end

  def self.update_credit_card_expiration_date(stripe_customer_id, card_month, card_year)
    run_with_stripe_exception_handler("Failed to update credit card expiration date") do
      Filly::CreditCard.update_expiration_date(stripe_customer_id, card_month, card_year)      
    end
  end
  
  private
  # :nocov:
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