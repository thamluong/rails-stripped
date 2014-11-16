class RegistrationsController < Devise::RegistrationsController
  
  def create    
    super    
    current_user.save_stripe_customer_id(guest_user.stripe_customer_id)
  end  
  
  def after_sign_up_path_for(resource)
    if session[:guest_user_id].blank?
      after_sign_in_path_for(resource)
    else
      download_path
    end
  end
  
end