class SubscriptionsController < ApplicationController
  layout 'stripe'  
  
  def new    
    @plan_name = params[:plan_name]      
  end
  
  def create    
    user_message = 'Subscription failed. We have been notified about this problem.'
    log_message = 'Credit card declined'
        
    run_with_stripe_exception_handler(log_message, user_message) do
      @success = Actors::Customer::UseCases.subscribe_to_a_plan(current_user, 
                                                                params[:stripeToken], 
                                                                params[:plan_name])    
      @plan_name = params[:plan_name]
    end
  end
    
end