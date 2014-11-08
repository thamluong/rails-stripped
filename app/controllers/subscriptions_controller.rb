class SubscriptionsController < ApplicationController
  layout 'subscribe'
  
  def new
    @plan_name = params[:plan_name]
  end
  
  def create
    stripe = StripeGateway.new(logger)
    @subscription = stripe.create_subscription('current_user.email', params[:stripeToken], params[:plan_name])
  end
  
  def pricing
  end
end
