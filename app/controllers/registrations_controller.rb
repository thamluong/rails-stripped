class RegistrationsController < Devise::RegistrationsController
  
  def new
    super
  end
  
  def create
    user = current_or_guest_user
    Actors::Customer::UseCases.register_for_an_account(user, params[:user][:email], params[:user][:password])
    sign_in(user)
    
    flash.notice = 'You have signed up'
      
    redirect_to root_path
  end  
    
end