class CreditCardsController < ApplicationController
  layout 'stripe'
  before_action :authenticate_user!
  
  def new
  end
  
  def create    
    begin
      @card = Actors::Customer::UseCases.add_new_credit_card(current_user, params[:stripeToken])
    rescue Exception => e
      StripeLogger.error "Add new credit card failed due to #{e.message}. #{e.backtrace.join("\n")}"
      redisplay_form("Add new credit card failed. We have been notified about this problem.")
    end
  end
  
  # This is used only for changing the expiration date when a customer clicks the link in the email.
  def edit
    @credit_card = current_user.credit_card
  end

  def update
    begin
      Actors::Customer::UseCases.update_credit_card_expiration_date(current_user, 
                                                                    params[:card_month], 
                                                                    params[:card_year])
      @user = current_user
      flash.notice = 'Credit card update successful'      
    rescue Exception => e
      StripeLogger.error " failed due to #{e.message}. #{e.backtrace.join("\n")}"
      redisplay_form(" failed. We have been notified about this problem.")
    end
  end
end