class RegistrationsController < Devise::RegistrationsController
  
  def create    
    super    
    StripeCustomer.transfer_guest_user_values_to_registered_user(guest_user, current_user)
  end  
  
  def after_sign_up_path_for(resource)
    if session[:guest_user_id].blank?
      after_sign_in_path_for(resource)
    else
      download_path
    end
  end
  
end