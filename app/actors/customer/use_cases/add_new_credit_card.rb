module Actors
  module Customer
    module UseCases
      
      def self.add_new_credit_card(user, stripe_token)
        card = StripeGateway.add_new_credit_card(user.stripe_customer_id, stripe_token)
              
        # Update our database with last 4 digits, expiration date and month.          
        StripeCustomer.save_credit_card_details(card, user)
        card
      end      
      
    end
  end
end