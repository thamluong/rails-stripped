module Actors
  module Customer
    module UseCases
      
      def self.guest_checkout(product_id, stripe_token, user)
        amount = Product.price_in_cents_for(product_id)
        customer = StripeGateway.save_credit_card(stripe_token)
        charge = StripeGateway.charge(amount, customer.id)
        
        StripeCustomer.save_credit_card_and_stripe_customer_id(customer, user)      
        StripeCustomer.create_payment(product_id, user.id, charge.id)
      end      
      
    end
  end
end