require 'rails_helper'

describe SubscriptionsController do
  
  it 'should initialize plan name' do
    get :new, {plan_name: 'gold'}
    
    expect(assigns(:plan_name)).to eq('gold')
  end
  
  it 'should delegate creating stripe customer to stripe gateway' do 
    sign_in   
    expect(Actors::Customer::UseCases).to receive(:subscribe_to_a_plan) { true }
  
    post :create, { stripeToken: '1', plan_name: 'gold'}
  end
  
  it 'should initialize the plan name to be displayed in create page' do 
    sign_in   
    allow(Actors::Customer::UseCases).to receive(:subscribe_to_a_plan) { true }
  
    post :create, { stripeToken: '1', plan_name: 'gold'}
    
    expect(assigns(:plan_name)).to eq('gold')
  end
  
  it 'should display new page when exception occurs in create action due to credit card decline' do
    allow(Actors::Customer::UseCases).to receive(:subscribe_to_a_plan) { raise Striped::CreditCardDeclined.new }
    
    post :create
    
    expect(response).to render_template(:new)  
  end
  
  it 'should render the new page when exception occurs' do
    allow(Actors::Customer::UseCases).to receive(:subscribe_to_a_plan) { raise Exception.new }
    
    post :create
    
    expect(response).to render_template(:new)  
  end
  
  it 'should render the new page when credit card exception occurs' do
    allow(Actors::Customer::UseCases).to receive(:subscribe_to_a_plan) { raise Striped::CreditCardException.new }
    
    post :create
    
    expect(response).to render_template(:new)  
  end

  it 'should initialize the error message when credit card exception occurs' do
    allow(Actors::Customer::UseCases).to receive(:subscribe_to_a_plan) { raise Striped::CreditCardException.new }
    
    post :create
    
    expect(assigns(:error_message)).to eq('Subscription failed. We have been notified about this problem.')
  end
  
end