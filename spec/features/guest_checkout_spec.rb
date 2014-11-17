require 'rails_helper'
require 'spec_helper'

feature 'Guest Checkout' do
  before(:all) do
    Product.create(name: 'Rails 4 Quickly', price: 47)  
  end
  
  scenario 'Complete purchase of one product and register for an account', js: true do
    visit products_show_path
    click_link 'Buy Now'
    
    fill_in "Card Number", with: '4242424242424242'    
    page.select '10', from: "card_month"
    page.select '2029', from: 'card_year'
    click_button 'Submit Payment'
    
    click_link 'Create your free account now'
    fill_in 'Email', with: test_email
    fill_in 'Password', with: '12345678'

    click_button 'Sign up'
        
    expect(page).to have_content('Welcome! You have signed up successfully')
    expect(page).to have_content('Download details about the book goes here')
  end

  scenario 'Complete purchase of one product and do not register for an account', js: true do
    visit products_show_path
    click_link 'Buy Now'
    
    fill_in "Card Number", with: '4242424242424242'    
    page.select '10', from: "card_month"
    page.select '2029', from: 'card_year'
    click_button 'Submit Payment'
    
    click_link 'No thanks, take me to my download'
        
    expect(page).to have_content('Download details about the book goes here')
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

  scenario 'Fails due to credit card expired', js: true do
    visit products_show_path
    click_link 'Buy Now'
    
    fill_in "Card Number", with: '4000000000000069'    
    page.select '10', from: "card_month"
    page.select '2029', from: 'card_year'
    click_button 'Submit Payment'
    
    expect(page).to have_content('Your card has expired.')
  end

  scenario 'Fails due to incorrect credit card number', js: true do
    visit products_show_path
    click_link 'Buy Now'
    
    fill_in "Card Number", with: '4242424242424241'    
    page.select '10', from: "card_month"
    page.select '2029', from: 'card_year'
    click_button 'Submit Payment'
      
    expect(page).to have_content('Your card number is incorrect.')    
  end

  scenario 'Fails due to credit card processing error', js: true do
    visit products_show_path
    click_link 'Buy Now'
    
    fill_in "Card Number", with: '4000000000000119'    
    page.select '10', from: "card_month"
    page.select '2029', from: 'card_year'
    click_button 'Submit Payment'
    
    expect(page).to have_content('An error occurred while processing your card. Try again in a little bit.')
  end
  
end