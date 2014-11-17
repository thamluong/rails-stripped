module Actors
  module Customer
    module UseCases
      
      def self.subscribe_to_a_plan(user, stripe_token, plan_name)
        stripe = StripeGateway.new
        customer = stripe.create_subscription(user.email, stripe_token, plan_name)    
                        
        subscription = Subscription.new(user_id: user.id)
        subscription.save_details(customer.id, plan_name)
      end      
      
    end
  end
end