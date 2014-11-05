class SubscriptionsController < ApplicationController
  def new
  end
  
  def create
    stripe = StripeGateway.new(Rails.logger)
    # TODO : Assumption : After integration with user authentication gem like Devise, replace
    # the hard-coded dummy value 'current_user.email'
    @subscription = stripe.create_subscription('current_user.email', params[:stripeToken], 'gold')
  end
  
end
