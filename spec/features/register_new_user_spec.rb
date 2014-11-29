require 'rails_helper'
require 'spec_helper'

feature 'Register' do  
  scenario 'A new user' do    
    visit root_path
    click_link 'Register'
    
    fill_in 'Email', with: test_email
    fill_in 'Password', with: '12345678'
    click_button 'Sign Up' 
    
    expect(page).to have_content('You have signed up!')
  end
end
