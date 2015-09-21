class SubscriptionsController < ApplicationController
  include StripeExceptionHandler
  layout 'stripe'  
  
  def new    
    @plan_name = params[:plan_name]      
  end
  
  def create    
    user_message = 'Subscription failed. We have been notified about this problem.'
    log_message = 'Credit card declined'
    main = -> do
      @success = Actors::Customer::UseCases.subscribe_to_a_plan(current_user, 
                                                                params[:stripeToken], 
                                                                params[:plan_name])    
      @plan_name = params[:plan_name]      
    end
        
    run_with_stripe_exception_handler(log_message, user_message, main)
  end
    
end