require 'rails_helper'
require 'spec_helper'

feature 'Guest Checkout' do
  before(:each) do
    Product.create(name: 'Rails 4 Quickly', price: 47)  
  end
  
  scenario 'Complete purchase of one product and register for an account', js: true do
    checkout_product
    make_payment('4242424242424242')
    register_after_guest_checkout(test_email, '12345678')
        
    expect(page).to have_content('You have signed up!')
  end

  scenario 'Complete purchase of one product and do not register for an account', js: true do
    checkout_product
    
    make_payment('4242424242424242')
    
    click_link 'No thanks, take me to my download'
        
    expect(page).to have_content('Download details about the book goes here')
  end
  
  scenario 'Fails due to credit card declined', js: true do
    checkout_product
    
    make_payment('4000000000000002')
    
    expect(page).to have_content('Your card was declined.')
  end

  scenario 'Fails due to credit card expired', js: true do
    checkout_product
    
    make_payment('4000000000000069')
        
    expect(page).to have_content('Your card has expired.')
  end

  scenario 'Fails due to incorrect credit card number', js: true do
    checkout_product
        
    make_payment('4242424242424241')
      
    expect(page).to have_content('Your card number is incorrect.')    
  end

  scenario 'Fails due to credit card processing error', js: true do
    checkout_product
        
    make_payment('4000000000000119')
    
    expect(page).to have_content('An error occurred while processing your card. Try again in a little bit.')
  end
  
end