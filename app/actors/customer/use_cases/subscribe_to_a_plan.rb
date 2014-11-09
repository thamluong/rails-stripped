module Actors
  module Customer
    module UseCases
      
      def self.subscribe_to_a_plan(email, stripe_token, plan_name, logger)
        stripe = StripeGateway.new(logger)
        customer = stripe.create_subscription(email, stripe_token, plan_name)    
        
        subscription = Subscription.new
        subscription.save_details(customer.id, plan_name)
      end      
      
    end
  end
end