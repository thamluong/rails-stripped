class SubscriptionsController < ApplicationController
  layout 'stripe'  
  
  def new    
    @plan_name = params[:plan_name]      
  end
  
  def create    
    begin      
      @success = Actors::Customer::UseCases.subscribe_to_a_plan(current_user, 
                                                                params[:stripeToken], 
                                                                params[:plan_name])    
      @plan_name = params[:plan_name]
    rescue Striped::CreditCardDeclined => e
      redisplay_form(e.message)
    rescue Striped::CreditCardException, Exception => e
      StripeLogger.error e.message
      redisplay_form("Subscription failed. We have been notified about this problem.")
    end
  end
    
end
