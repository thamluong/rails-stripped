require 'rails_helper'
require 'spec_helper'

feature 'Credit Card Update' do

  scenario 'signup, subscribe, edit credit card expiration date', js: true do
    # signup
    visit new_user_registration_path
    fill_in 'Email', with: test_email
    fill_in 'Password', with: '12345678'
    click_button 'Sign up'
    
    # subscribe
    visit pricing_path    
    click_link 'Gold'
    fill_in "Card Number", with: '4242424242424242'
    page.select '10', from: "card_month"
    page.select '2029', from: 'card_year'
    click_button 'Subscribe Me'
    
    # Need to wait for response from Stripe servers before we can continue.
    sleep 5
    
    # edit cc expiration date
    visit credit_cards_edit_path    
    page.select '10', from: "card_month"
    page.select '2028', from: 'card_year'
    click_button 'Change Expiration Date'
    
   expect(page).to have_content('Credit card update successful')  
  end

end