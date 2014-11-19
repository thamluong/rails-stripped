require 'rails_helper'
require 'stripe_mock'

describe StripeController, :type => :controller do

  before do
    user = User.new(email: 'dummy@email.com', stripe_customer_id: 'cus_5Ai7NfoTq4ECl8')
    user.save(validate: false)
  end

  it "returns http success" do
    h = JSON.parse(File.read("spec/support/fixtures/subscription_charge_failed.json"))
    event = Stripe::Event.construct_from(h)    
    allow(Stripe::Event).to receive(:retrieve) { event }
        
    post :webhook, h
    
    expect(response).to be_success
  end

  it "sends email when subscription charge fails" do
    h = JSON.parse(File.read("spec/support/fixtures/subscription_charge_failed.json"))
    event = Stripe::Event.construct_from(h)    
    allow(Stripe::Event).to receive(:retrieve) { event }
            
    expect { post :webhook, h }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

end
