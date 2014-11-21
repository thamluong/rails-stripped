require 'rails_helper'
require 'spec_helper'

feature 'One click checkout' do
  before(:each) do
    Product.create(name: 'Rails 4 Quickly', price: 47)  
  end
  
  scenario 'guest checkout, register and one-click checkout in subsequent visit', js: true do
    # 1. A customer makes a purchase as a guest. 
    visit products_show_path
    click_link 'Buy Now'
    
    fill_in "Card Number", with: '4242424242424242'    
    page.select '10', from: "card_month"
    page.select '2029', from: 'card_year'
    click_button 'Submit Payment'
    
    # 2. Registers for an account.  
    click_link 'Create your free account now'
    fill_in 'Email', with: 'test@example.com'
    fill_in 'Password', with: '12345678'
    click_button 'Sign up'
    
    # 3. Logs out.
    click_link 'Logout'
    
    # 4. Logs in.
    click_link 'Login'
    fill_in 'Email', with: 'test@example.com'
    fill_in 'Password', with: '12345678'
    click_button 'Log in'
    
    # 5. Makes a purchase without providing any credit card details using one-click checkout.
    visit products_show_path
    click_link 'Buy Now'
    
    expect(page).to have_content('Download details about the book goes here')
  end
    
end