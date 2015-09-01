class StripeController < ApplicationController
  protect_from_forgery except: :webhook
  
  SUBSCRIPTION_PAYMENT_FAILED = "invoice.payment_failed"
  
  def webhook    
    StripeLogger.info "Received event with ID: #{params[:id]} Type: #{params[:type]}"

    # Retrieving the event from the Stripe API guarantees its authenticity  
    event = Stripe::Event.retrieve(params[:id])

    if event.type == SUBSCRIPTION_PAYMENT_FAILED
      stripe_customer_token = event.data.object.customer
      Actors::Stripe::UseCases.process_subscription_payment_failure(stripe_customer_token)
    else
      StripeLogger.info "Webhook received params.inspect. Did not handle this event."  
    end  
    
    render text: "success"
  end  

  # Next version should be like this:
  # def webhook
  #   subscription_payment = Colt::SubscriptionPayment.new(params[:id])
  #
  #   if subscription_payment.failed?
  #     stripe_customer_token = subscription_payment.stripe_customer_token
  #     #
  #   else
  #     #
  #   end
  # end
    
end


