require 'rails_helper'

describe 'Process subscription payment failure' do
  it 'sends subscription payment failed email' do
    user = User.new(stripe_customer_id: 10, email: 'test@example.com')
    user.save(validate: false)
    
    expect do
      Actors::Stripe::UseCases.process_subscription_payment_failure(10)
    end.to change { ActionMailer::Base.deliveries.count }.by(1)
  end
end