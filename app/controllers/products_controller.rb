class ProductsController < ApplicationController
  def show
    @product = Product.first
  end
  
  def download
    
  end
end
