require 'rails_helper'
require 'spec_helper'

feature 'Subscription' do
    
  scenario 'Customer subscribes to Gold plan', js: true do
    sign_up('test@example.com', '12345678') 

    subscribe_to_a_plan('Gold', '4242424242424242')
    
    expect(page).to have_content('You have been subscribed to Gold.')
  end
  
  scenario 'Customer credit card expired', js: true do
    sign_up('test@example.com', '12345678') 
    
    subscribe_to_a_plan('Gold', '4000000000000069')
        
    expect(page).to have_content('Your card has expired.')
  end
  
  scenario 'Customer credit card number incorrect', js: true do
    sign_up('test@example.com', '12345678') 
    
    subscribe_to_a_plan('Gold', '4242424242424241')
    
    expect(page).to have_content('Your card number is incorrect.')    
  end

  scenario 'Customer credit card declined', js: true do
    sign_up('test@example.com', '12345678') 
    
    subscribe_to_a_plan('Gold', '4000000000000002')
    
    expect(page).to have_content('Your card was declined.')
  end

  scenario 'Customer credit card processing error', js: true do
    sign_up('test@example.com', '12345678') 
    
    subscribe_to_a_plan('Gold', '4000000000000119')
    
    expect(page).to have_content('An error occurred while processing your card. Try again in a little bit.')
  end
  
end