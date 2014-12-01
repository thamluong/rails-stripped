class SalesController < ApplicationController
  layout 'stripe'  
  
  def new
    begin
      user = current_or_guest_user
      if user.has_saved_credit_card?
        @payment = Actors::Customer::UseCases.one_click_checkout(user, params[:id])
        
        redirect_to download_path(payment_id: @payment, product_id: params[:id])
      else
        session[:product_id] = params[:id]
      end
    rescue Striped::CreditCardDeclined => e
      redisplay_form(e.message)
    rescue Exception => e
      StripeLogger.error "One Click Checkout failed due to #{e.message}. #{e.backtrace.join("\n")}"
      redisplay_form("Checkout failed. We have been notified about this problem.")
    end
  end

  def create    
    begin
      user = current_or_guest_user
      session[:guest_checkout] = 1
      @payment = Actors::Customer::UseCases.guest_checkout(session[:product_id], params[:stripeToken], user)
      @product = Product.find(session[:product_id])
    rescue Striped::CreditCardDeclined => e
      redisplay_form(e.message)
    rescue Exception => e
      StripeLogger.error "Guest checkout failed due to #{e.message}. #{e.backtrace.join("\n")}"
      redisplay_form("Checkout failed. We have been notified about this problem.")
    ensure
      session[:product_id] = nil
      session[:guest_checkout] = nil
    end
  end
  
end


