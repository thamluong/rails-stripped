class Subscription < ActiveRecord::Base
  
  def plan_display_name
    case self.plan_name
    when 1
      'Silver'
    when 'gold'
      'Gold'
    when 3
      'Platinum'
    else
      'Unknown'
    end
  end
  
  def complete?
    self.stripe_customer_token.present?
  end
end
