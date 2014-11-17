class SalesController < ApplicationController
  layout 'sales'
  
  def new
    session[:product_id] = params[:id]
  end

  def create
    begin
      user = current_or_guest_user
      Actors::Customer::UseCases.guest_checkout(session[:product_id], params[:stripeToken], user)
    rescue Striped::CreditCardDeclined => e
      redisplay_form(e.message)
    rescue Exception => e
      logger.error "Guest checkout failed due to #{e.message}"
      redisplay_form("Checkout failed. We have been notified about this problem.")
    ensure
      session[:product_id] = nil
    end
  end
end