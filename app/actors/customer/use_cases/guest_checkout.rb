module Actors
  module Customer
    module UseCases
      
      def self.guest_checkout(amount, stripe_token, user, logger)
        stripe_gateway = StripeGateway.new(logger)
        customer_id = stripe_gateway.charge(amount, stripe_token)

        user.save_stripe_customer_id(customer_id)      
      end      
      
    end
  end
end