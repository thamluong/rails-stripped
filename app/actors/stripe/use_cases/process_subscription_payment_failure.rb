module Actors
  module Stripe
    module UseCases
      
      def self.process_subscription_payment_failure(stripe_customer_token)
        user = User.where(stripe_customer_id: stripe_customer_token).first

        UserMailer.subscription_payment_failed(user).deliver_now
      end      
      
    end
  end
end