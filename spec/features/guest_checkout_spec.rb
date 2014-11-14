require 'rails_helper'
require 'spec_helper'

feature 'Guest Checkout' do
  scenario 'Complete purchase of one product', js: true do
    visit products_show_path
    click_link 'Buy Now'
    
    fill_in "Card Number", with: '4242424242424242'    
    page.select '10', from: "card_month"
    page.select '2029', from: 'card_year'
    click_button 'Submit Payment'
    
    expect(page).to have_content('Receipt')
  end
  
  scenario 'Fails due to credit card declined', js: true do
    visit products_show_path
    click_link 'Buy Now'
    
    fill_in "Card Number", with: '4000000000000002'    
    page.select '10', from: "card_month"
    page.select '2029', from: 'card_year'
    click_button 'Submit Payment'
    
    expect(page).to have_content('Your card was declined.')
  end
end    