class WelcomeController < ApplicationController
  def index
    if user_signed_in?
      @orders = current_user.orders if current_user.has_orders? 
    end
  end
  
  def pricing
  end
end
