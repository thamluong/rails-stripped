class SubscriptionsController < ApplicationController
  layout 'subscribe'
  
  def new
    @plan_name = params[:plan_name]
  end
  
  def create
    @subscription = Actors::Customer::UseCases.subscribe_to_a_plan('current_user.email', 
                                                                   params[:stripeToken], 
                                                                   params[:plan_name], 
                                                                   logger)    
  end
  
  def pricing
  end
end
