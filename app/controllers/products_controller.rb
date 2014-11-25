class ProductsController < ApplicationController
  
  def show
    @product = Product.first
  end
  
  def download
    @credit_card = current_user.try(:credit_card)
  end
end
