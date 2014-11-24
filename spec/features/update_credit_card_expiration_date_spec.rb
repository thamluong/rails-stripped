require 'rails_helper'
require 'spec_helper'

feature 'Credit Card Update' do

  scenario 'signup, subscribe, edit credit card expiration date', js: true do
    # signup
    sign_up(test_email, '12345678')
    
    # subscribe
    visit pricing_path    
    subscribe_to_a_plan('Gold', '4242424242424242')
    
    # Need to wait for response from Stripe servers before we can continue.
    sleep 5
    
    # edit cc expiration date
    change_credit_card_expiration_date
        
    expect(page).to have_content('Credit card update successful')  
  end

end