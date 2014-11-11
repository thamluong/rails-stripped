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
    rescue Exception => ex
      @logger.error "Create subscription failed due to : #{ex.message}"  
    end
  end
  
end