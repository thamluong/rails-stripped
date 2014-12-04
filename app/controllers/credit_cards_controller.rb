class CreditCardsController < ApplicationController
  layout 'stripe'
  before_action :authenticate_user!
  
  def new
  end
  
  
  def create    
    log_message = 'Add new credit card failed due to'
    user_message = 'Add new credit card failed. We have been notified about this problem.'
    
    run_with_exception_handler(log_message, user_message) do
      @card = Actors::Customer::UseCases.add_new_credit_card(current_user, params[:stripeToken])
    end
  end
  
  # This is used only for changing the expiration date when a customer clicks the link in the email.
  def edit
    @credit_card = current_user.credit_card
  end

  def update
    log_message = 'Credit card update failed due to'
    user_message = 'Credit card update failed. We have been notified about this problem.'
    
    run_with_exception_handler(log_message, user_message) do
      Actors::Customer::UseCases.update_credit_card_expiration_date(current_user, 
                                                                    params[:card_month], 
                                                                    params[:card_year])
      @user = current_user
      flash.notice = 'Credit card update successful'      
    end    
  end
  
end