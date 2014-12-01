require 'rails_helper'

describe SalesController, :type => :controller do

  before(:each) do
    @product = Product.create(name: 'Rails 4 Quickly', price: 47)  
  end

  it "returns http success" do
    get :new
    
    expect(response).to be_success
  end

  it 'should display download page after one-click checkout' do 
    user = User.new
    user.save(validate: false)
    sign_in(user)
    allow(user).to receive(:has_saved_credit_card?) { true }
    @payment = Payment.create(user_id: user.id, product_id: @product.id, receipt_number: 'abc')   
    allow(Actors::Customer::UseCases).to receive(:one_click_checkout) { @payment }

    get :new, { id: @product.id }
    
    expect(subject).to redirect_to(download_path(product_id: @product, payment_id: @payment))
  end
  
  it 'should render the new page when exception occurs in new action' do    
    user = User.new
    user.save(validate: false)
    sign_in(user)
    allow(user).to receive(:has_saved_credit_card?) { true }
    allow(Actors::Customer::UseCases).to receive(:one_click_checkout) { raise Striped::CreditCardDeclined.new }
    
    get :new
    
    expect(response).to render_template(:new)  
  end

  it 'should display new page when exception occurs' do
    user = User.new
    user.save(validate: false)
    sign_in(user)
    allow(user).to receive(:has_saved_credit_card?) { raise Exception.new }    
    
    get :new
    
    expect(response).to render_template(:new)  
  end
  
  it 'should delegate guest checkout to use case handler' do 
    sign_in   
    expect(Actors::Customer::UseCases).to receive(:guest_checkout) { true }

    post :create, { stripeToken: '1', plan_name: 'gold'}
  end

  it 'should render the new page when exception occurs in create action' do
    allow(Actors::Customer::UseCases).to receive(:guest_checkout) { raise Striped::CreditCardDeclined.new }
    
    post :create
    
    expect(response).to render_template(:new)  
  end

  it 'should render the new page when exception occurs in create action' do
    allow(Actors::Customer::UseCases).to receive(:guest_checkout) { raise Exception.new }
    
    post :create
    
    expect(response).to render_template(:new)  
  end

end
