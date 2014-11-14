module Features
  module SessionHelpers
    def sign_up(email, password)
      User.destroy_all
      visit new_user_registration_path
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      
      click_button 'Sign up'
    end
  end
end