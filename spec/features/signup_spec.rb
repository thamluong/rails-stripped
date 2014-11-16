require 'rails_helper'
require 'spec_helper'

feature 'Signup' do
  after do
    User.destroy_all
  end
  
  scenario 'User with email and password' do    
    sign_up(test_email, '12345678')
    
    expect(page).to have_content('Gold')
  end
end
