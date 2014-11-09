class StripeGateway
  def initialize(logger)
    @logger = logger
  end
  
  def create_subscription(email, stripe_token, plan_id)
    begin
      customer = Stripe::Customer.create(description: email, card: stripe_token, plan: plan_id)
    rescue Stripe::InvalidRequestError => e
      @logger.error "Create subscription failed due to Stripe::InvalidRequestError : #{e.message}"
    rescue Exception => ex
      @logger.error "Create subscription failed due to : #{ex.message}"  
    end
  end
  
end