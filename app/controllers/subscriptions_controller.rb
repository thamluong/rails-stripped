class SubscriptionsController < ApplicationController
  layout 'subscribe'
  
  def new
    @plan_name = params[:plan_name]
  end
  
  def create
    begin
      @subscription = Actors::Customer::UseCases.subscribe_to_a_plan('current_user.email', 
                                                                     params[:stripeToken], 
                                                                     params[:plan_name], 
                                                                     logger)    
    rescue Striped::CreditCardDeclined => e
      @error_message = e.message
      @subscription = Subscription.new
                  
      render :new
    end
  end
  
  def pricing
  end
end
