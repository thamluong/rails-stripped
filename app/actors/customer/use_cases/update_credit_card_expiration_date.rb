module Actors
  module Customer
    module UseCases
      
      def self.update_credit_card_expiration_date(user, card_month, card_year)
        cc = StripeGateway.save_credit_card_details(user.stripe_customer_id, card_month, card_year)
        
        user.save_credit_card_details(cc.last4, cc.exp_month, cc.exp_year)
      end      
      
    end
  end
end