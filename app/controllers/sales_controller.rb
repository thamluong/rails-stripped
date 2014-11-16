class SalesController < ApplicationController
  layout 'sales'
  
  def new
  end

  def create
    begin
      user = current_or_guest_user
      # TODO : The price must come from product model.
      amount = 2700
      Actors::Customer::UseCases.guest_checkout(amount, params[:stripeToken], user, logger)
    rescue Striped::CreditCardDeclined => e
      redisplay_form(e.message)
    rescue Exception => e
      logger.error "Guest checkout failed due to #{e.message}"
      redisplay_form("Checkout failed. We have been notified about this problem.")
    end
  end
end