class StripeGateway
  def initialize(logger)
    @logger = logger
  end
  
  def create_subscription(email, stripe_token, plan_id)
    begin
      customer = Stripe::Customer.create(description: email, card: stripe_token, plan: plan_id)
    rescue Stripe::CardError => e
      # Since it's a decline, Stripe::CardError will be caught
      body = e.json_body
      err  = body[:error]

      @logger.error "Status is: #{e.http_status}"
      @logger.error "Type is: #{err[:type]}"
      @logger.error "Code is: #{err[:code]}"
      # param is '' in this case
      @logger.error "Param is: #{err[:param]}"
      @logger.error "Message is: #{err[:message]}" 

      raise Striped::CreditCardDeclined.new(err[:message])     
    rescue Stripe::InvalidRequestError => e
      @logger.error "Create subscription failed due to Stripe::InvalidRequestError : #{e.message}"
      
      raise Striped::CreditCardException.new(e.message)
    rescue Stripe::AuthenticationError => e
      @logger.error "Authentication with Stripe's API failed"
      @logger.error "(maybe you changed API keys recently)"
      
      raise Striped::CreditCardException.new(e.message)
    rescue Stripe::APIConnectionError => e
      @logger.error "Network communication with Stripe failed"
    
      raise Striped::CreditCardException.new(e.message)
    rescue Stripe::StripeError => e
      @logger.error "Display a very generic error to the user, and maybe send yourself an email"
      
      raise Striped::CreditCardException.new(e.message)
    rescue Exception => ex
      @logger.error "Create subscription failed due to : #{ex.message}"  
      
      raise
    end
  end
  
  def charge(amount, stripe_token)
    # amount in cents, again
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
    
      @logger.error "Status is: #{e.http_status}"
      @logger.error "Type is: #{err[:type]}"
      @logger.error "Code is: #{err[:code]}"
      # param is '' in this case
      @logger.error "Param is: #{err[:param]}"
      @logger.error "Message is: #{err[:message]}" 
    
      raise Striped::CreditCardDeclined.new(err[:message])     
    rescue Exception => ex
      @logger.error "Purchase failed due to : #{ex.message}"  
      
      raise
    end
  end
end