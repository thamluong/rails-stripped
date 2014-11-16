class Subscription < ActiveRecord::Base
  belongs_to :user
  
  def plan_display_name
    self.plan_name.humanize
  end
  
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