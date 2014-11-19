class StripeController < ApplicationController
  protect_from_forgery except: :webhook
  
  SUBSCRIPTION_PAYMENT_FAILED = "invoice.payment_failed"
  
  def webhook    
    StripeLogger.info "Received event with ID: #{params[:id]} Type: #{params[:type]}"

    # Retrieving the event from the Stripe API guarantees its authenticity  
    event = Stripe::Event.retrieve(params[:id])

    if event.type == SUBSCRIPTION_PAYMENT_FAILED
      stripe_customer_token = event.data.object.customer
      user = User.where(stripe_customer_id: stripe_customer_token).first
      
      UserMailer.suscription_payment_failed(user).deliver
    else
      StripeLogger.info "Webhook received params.inspect. Did not handle this event."  
    end  
    
    render text: "success"
  end  
  
end