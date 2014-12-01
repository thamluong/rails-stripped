class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_one :subscription
  has_one :credit_card
  has_many :payments
  
  def save_stripe_customer_id(sci)
    self.stripe_customer_id = sci
    save
  end
  
  def has_saved_credit_card?
    !stripe_customer_id.nil?
  end
  
  def self.generate_random_guest_email
    "guest_#{Time.now.to_i}#{rand(100)}@example.com"
  end
  
  def update_credit_card_expiration_date(expiration_month, expiration_year)
    self.credit_card.update_credit_card_expiration_date(expiration_month, expiration_year)
  end

  def orders
    Order.all(payments)
  end
end
