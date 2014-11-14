require 'rails_helper'
require 'spec_helper'

feature 'Signup' do
  
  scenario 'User with email and password' do    
    sign_up('test@example.com', '12345678')
    
    expect(page).to have_content('Gold')
  end
end
