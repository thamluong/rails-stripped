class UserMailer < ActionMailer::Base
  default from: "from@your-domain.com"
  
  def suscription_payment_failed(user)
    @user = user
    @url = credit_cards_edit_url
    
    mail(to: @user.email, subject: 'Payment to RubyPlus Failed')
  end
end
