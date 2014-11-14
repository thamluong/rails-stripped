class SalesController < ApplicationController
  layout 'sales'
  
  def new
  end

  def create
    begin
      stripe_gateway = StripeGateway.new(logger)
      stripe_gateway.charge(2700, params[:stripeToken])
    rescue Striped::CreditCardDeclined => e
      redisplay_form(e.message)
    rescue Exception => e
      redisplay_form("Subscription failed. We have been notified about this problem.")
    end
  end
end