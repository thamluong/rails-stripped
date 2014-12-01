class WelcomeController < ApplicationController
  def index
    @orders = current_user.orders if user_signed_in?
  end
  
  def pricing
  end
end
