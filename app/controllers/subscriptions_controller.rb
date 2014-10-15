class SubscriptionsController < ApplicationController
  def new
  end
  
  def create
    stripe = StripeGateway.new(Rails.logger)
    @subscription = stripe.create_subscription('current_user.email', params[:stripeToken], 2)
  end
  
end
