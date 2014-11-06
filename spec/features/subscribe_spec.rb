require 'rails_helper'

feature 'Subscription' do
  scenario 'Customer subscribes to Gold plan', js: true do
    visit "/subscriptions/new"
    fill_in "Card Number", with: '4242424242424242'
    page.select '10', from: "card_month"
    page.select '2029', from: 'card_year'
    
    click_button 'Subscribe Me'
    expect(page).to have_content('You have been subscribed to Gold.')
  end
end