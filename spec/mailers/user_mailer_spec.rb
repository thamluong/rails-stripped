require "rails_helper"

describe UserMailer, :type => :mailer do
  it 'has from@your-domain.com as the from email address' do
    user = User.new(email: 'bugs@rubyplus.com')
    
    email = UserMailer.subscription_payment_failed(user).deliver_now

    expect(email.from).to eq(['from@your-domain.com'])
  end
  
  it 'delivers email to the correct email recepient' do
    user = User.new(email: 'bugs@rubyplus.com')
    
    email = UserMailer.subscription_payment_failed(user).deliver_now
    
    expect(email).to deliver_to("bugs@rubyplus.com")
  end
    
  it 'has Payment to RubyPlus Failed as the subject of the email' do
    user = User.new(email: 'bugs@rubyplus.com')
    
    email = UserMailer.subscription_payment_failed(user).deliver_now

    expect(email.subject).to eq('Payment to RubyPlus Failed')
  end
  
  it 'has link to edit credit card url in the email' do
    user = User.new(email: 'bugs@rubyplus.com')
    
    email = UserMailer.subscription_payment_failed(user).deliver_now

    expect(email).to have_body_text(/#{credit_cards_edit_url}/)
  end
end