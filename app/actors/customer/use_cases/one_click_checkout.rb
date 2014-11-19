module Actors
  module Customer
    module UseCases
      
      def self.one_click_checkout(user, product_id)
        customer_id = user.stripe_customer_id
        amount = Product.price_in_cents_for(product_id)
        
        StripeGateway.charge(amount, customer_id)
      end      
      
    end
  end
end