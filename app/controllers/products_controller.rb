class ProductsController < ApplicationController
  
  def show
    @product = Product.first
  end
    
  def download
    @payment = Payment.find(params[:payment_id])
    @product = Product.find(params[:product_id])
    @credit_card = current_user.try(:credit_card)
    # Clear the session if they don't register after guest checkout
#    session[:guest_checkout] = nil
  end
end
