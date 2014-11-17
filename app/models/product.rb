class Product < ActiveRecord::Base
  def price_in_cents
    (price * 100).to_i
  end
  
  def self.price_in_cents_for(product_id)
    product = Product.find(product_id)
    product.price_in_cents
  end
end
