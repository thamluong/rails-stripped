module Features
  module SessionHelpers
    def sign_up(email, password)
      visit new_user_registration_path
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      
      click_button 'Sign up'
    end
    
    def subscribe_to_a_plan(plan, credit_card)
      click_link plan
      fill_in "Card Number", with: credit_card
      page.select '10', from: "card_month"
      page.select '2029', from: 'card_year'

      click_button 'Subscribe Me'
    end
    
    def test_email
      "guest_#{Time.now.to_i}#{rand(100)}@example.com"
    end
  end
end