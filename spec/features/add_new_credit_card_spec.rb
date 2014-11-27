require 'rails_helper'
require 'spec_helper'

feature 'Add New Credit Card' do  
  before(:each) do
    Product.create(name: 'Rails 4 Quickly', price: 47)  
  end
  
  let(:email) { test_email }
  let(:password) { '12345678' }
  
  scenario 'The new credit card becomes the default card', js: true do    
    # 1. A customer makes a purchase as a guest. 
     checkout_product
     make_payment('4242424242424242')

     # 2. Registers for an account.  
     register_after_guest_checkout(email, password)

     # 3. Logs out.
     logout

     # 4. Logs in.
     login(email, password)
     
     # 5. Add new credit card
     visit credit_cards_new_path

     add_new_credit_card('4012888888881881')
     
     expect(page).to have_content('Your credit card ending in last 4 digits 1881 has been added.')
  end
end
