require 'rails_helper'
require 'spec_helper'

feature 'One click checkout' do
  before(:each) do
    Product.create(name: 'Rails 4 Quickly', price: 47)  
  end
  
  scenario 'guest checkout, register and one-click checkout in subsequent visit', js: true do
    # 1. A customer makes a purchase as a guest. 
    checkout_product
    make_payment('4242424242424242')
    
    # 2. Registers for an account.  
    register_after_guest_checkout('test@example.com', '12345678')
    
    # 3. Logs out.
    # logout
    
    # 4. Logs in.
    # login('test@example.com', '12345678')
    
    # 5. Makes a purchase without providing any credit card details using one-click checkout.
    checkout_product
    
    expect(page).to have_content('Your credit card ending in 4242 has been charged for this purchase')
    expect(page).to have_content('Download details about the book goes here')
  end
    
end