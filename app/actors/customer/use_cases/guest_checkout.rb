module Actors
  module Customer
    module UseCases
      
      def self.guest_checkout(product_id, stripe_token, user)
        amount = Product.price_in_cents_for(product_id)
        customer_id = StripeGateway.save_credit_card_and_charge(amount, stripe_token)

        user.save_stripe_customer_id(customer_id)      
      end      
      
    end
  end
end