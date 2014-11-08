class StripeGateway
  def initialize(logger)
    @logger = logger
  end
  
  def create_subscription(email, stripe_token, plan_id)
    begin
      customer = Stripe::Customer.create(description: email, card: stripe_token, plan: plan_id)
      subscription = Subscription.new
      subscription.stripe_customer_token = customer.id
      subscription.plan_name = plan_id
      subscription.save!
      subscription
    rescue Stripe::InvalidRequestError => e
      @logger.error "Create subscription failed due to Stripe::InvalidRequestError : #{e.message}"
    rescue Exception => ex
      @logger.error "Create subscription failed due to : #{ex.message}"  
    end
  end
  
end