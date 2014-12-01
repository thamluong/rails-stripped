class Order
  def self.all(payments)
    orders = []
    payments.each do |payment|
      order = {}
      product = Product.find(payment.product_id)
      order[:product_name] = product.name
      order[:amount] = payment.amount
      orders << order
    end
    orders
  end
end