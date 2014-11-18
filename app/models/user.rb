class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_one :subscription
  
  def save_stripe_customer_id(sci)
    self.stripe_customer_id = sci
    save!                
  end
  
  def has_saved_credit_card?
    !stripe_customer_id.nil?
  end
end
