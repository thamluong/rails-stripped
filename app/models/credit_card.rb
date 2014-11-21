class CreditCard < ActiveRecord::Base
  belongs_to :user
  
  def update_credit_card_expiration_date(last4digits, expiration_month, expiration_year)
    self.last4digits = last4digits
    self.expiration_month = expiration_month
    self.expiration_year = expiration_year
    self.save!
  end
end
