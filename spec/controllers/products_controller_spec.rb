require 'rails_helper'

describe ProductsController, :type => :controller do

  it "returns http success for show action" do
    get :show
  
    expect(response).to be_success
  end

  context 'download page' do
    before(:each) do
      @product = Product.create(name: 'Rails 4 Quickly', price: 47)  
      User.create(email: 'bugs@disney.com', password: '12345678')
      @user = User.last
      @user.create_credit_card(last4digits: 1234)
      @payment = Payment.create(user_id: @user.id, product_id: @product.id, receipt_number: 'abc')
    end
    
    it "returns http success for download action" do
      sign_in(@user)   

      get :download, {product_id: @product, payment_id: @payment}

      expect(response).to be_success
    end

    it "returns http success for download action for guest user" do
      get :download, {product_id: @product, payment_id: @payment}

      expect(response).to be_success
    end

    it "initializes credit card for download action" do
      sign_in(@user)   

      get :download, {product_id: @product, payment_id: @payment}

      expect(assigns[:credit_card].last4digits).to eq('1234')
    end
    
    
  end
    
end
