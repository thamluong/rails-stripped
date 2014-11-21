module Actors
  module Customer
    module UseCases
      
      def self.subscribe_to_a_plan(user, stripe_token, plan_name)
        customer = StripeGateway.create_subscription(user.email, stripe_token, plan_name)    
        
        StripeCustomer.save_subscription_details(user, customer, plan_name)
      end      
      
    end
  end
end