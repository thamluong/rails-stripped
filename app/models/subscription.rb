class Subscription < ActiveRecord::Base
  belongs_to :user
      
  def complete?
    self.stripe_customer_token.present?
  end
  
  def save_details(customer_id, plan_id)
    self.stripe_customer_token = customer_id
    self.plan_name = plan_id
    self.save!
    self
  end
end