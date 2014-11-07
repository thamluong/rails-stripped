class SubscriptionsController < ApplicationController
  layout 'subscribe'
  
  def new
    @subscription = Subscription.new(params.permit(:plan_name))    
  end
  
  def create
    stripe = StripeGateway.new(logger)
    # TODO : Assumption : After integration with user authentication gem like Devise, replace
    # the hard-coded dummy value 'current_user.email'        
    @subscription = stripe.create_subscription('current_user.email', params[:stripeToken], params[:plan_name])
  end
  
  def pricing
  end
end
