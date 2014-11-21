class CreditCardsController < ApplicationController
  before_action :authenticate_user!
  
  def edit
    # TODO : Only users who have already subscribed or purchased a product will have a credit card.
    # Do not display credit card edit form if they don't have a credit card
    @credit_card = CreditCard.where(user_id: current_user.id).first    
  end

  def update
    Actors::Customer::UseCases.update_credit_card_expiration_date(current_user, 
                                                                  params[:card_month], 
                                                                  params[:card_year])
    @user = current_user
    flash.notice = 'Credit card update successful'    
  end
end