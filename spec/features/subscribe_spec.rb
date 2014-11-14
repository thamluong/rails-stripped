require 'rails_helper'
require 'spec_helper'

feature 'Subscription' do
    
  scenario 'Customer subscribes to Gold plan', js: true do
    sign_up('test@example.com', '12345678') 

    click_link 'Gold'
    fill_in "Card Number", with: '4242424242424242'
    page.select '10', from: "card_month"
    page.select '2029', from: 'card_year'
     
    click_button 'Subscribe Me'
    expect(page).to have_content('You have been subscribed to Gold.')
  end
  
  scenario 'Customer credit card expired', js: true do
    sign_up('test@example.com', '12345678') 
        
    click_link 'Gold'
    fill_in "Card Number", with: '4000000000000069'
    page.select '10', from: "card_month"
    page.select '2029', from: 'card_year'
    
    click_button 'Subscribe Me'
    expect(page).to have_content('Your card has expired.')
  end
  
  scenario 'Customer credit card number incorrect', js: true do
    sign_up('test@example.com', '12345678') 
    
    click_link 'Gold'
    fill_in "Card Number", with: '4242424242424241'
    page.select '10', from: "card_month"
    page.select '2029', from: 'card_year'
    
    click_button 'Subscribe Me'
    expect(page).to have_content('Your card number is incorrect.')    
  end

  scenario 'Customer credit card declined', js: true do
    sign_up('test@example.com', '12345678') 
    
    click_link 'Gold'
    fill_in "Card Number", with: '4000000000000002'
    page.select '10', from: "card_month"
    page.select '2029', from: 'card_year'
    
    click_button 'Subscribe Me'
    expect(page).to have_content('Your card was declined.')
  end

  scenario 'Customer credit card processing error', js: true do
    sign_up('test@example.com', '12345678') 
    
    click_link 'Gold'
    fill_in "Card Number", with: '4000000000000119'
    page.select '10', from: "card_month"
    page.select '2029', from: 'card_year'
    
    click_button 'Subscribe Me'
    expect(page).to have_content('An error occurred while processing your card. Try again in a little bit.')
  end
  
end