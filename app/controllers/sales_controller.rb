class SalesController < ApplicationController
  layout 'stripe'  
  
  def new
    log_message = 'One Click Checkout failed due to'
    user_message = 'Checkout failed. We have been notified about this problem.'
    
    main = -> do
      user = current_or_guest_user
      if user.has_saved_credit_card?
        @payment = Actors::Customer::UseCases.one_click_checkout(user, params[:id])
        
        redirect_to download_path(payment_id: @payment, product_id: params[:id])
      else
        session[:product_id] = params[:id]
      end
    end    
    
    run_with_stripe_exception_handler(log_message, user_message, main)        
  end
  
  def create    
    log_message = 'Guest checkout failed due to'
    user_message = 'Checkout failed. We have been notified about this problem'
    
    cleanup = -> { session[:product_id] = nil }
    main = -> do
      user = current_or_guest_user
      @payment = Actors::Customer::UseCases.guest_checkout(session[:product_id], params[:stripeToken], user)
      @product = Product.find(session[:product_id])      
    end
    
    run_with_stripe_exception_handler(log_message, user_message, main, cleanup)
  end
  
end