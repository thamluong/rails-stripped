class Subscription < ActiveRecord::Base
  
  def plan_display_name
    self.plan_name.humanize
  end
  
  def complete?
    self.stripe_customer_token.present?
  end
end
