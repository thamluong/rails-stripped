class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_one :subscription
  has_one :credit_card
  
  def save_stripe_customer_id(sci)
    self.stripe_customer_id = sci
    save(validate: false)                
  end
  
  def has_saved_credit_card?
    !stripe_customer_id.nil?
  end

  def save_credit_card_details(last4digits, expiration_month, expiration_year)
    self.credit_card.save_credit_card_details(last4digits, expiration_month, expiration_year)
  end
  
end
