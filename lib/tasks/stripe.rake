
desc 'Check Stripe Credentials'
namespace :stripe do
  task :credentials_check => :environment do
    message = <<ERROR 
Stripe Credentials is not set. Define the following Stripe Environment variables.

export STRIPE_PUBLISHABLE_KEY='pk_test_your publishable key' 
export STRIPE_SECRET_KEY='sk_test_your secret key'

Check config/initializers/stripe.rb for more details on this works.
ERROR
              
    if Rails.configuration.stripe[:secret_key].blank?
      puts message
    else
      begin
        Stripe::Account.retrieve
        puts "Stripe Secret Key is defined properly"
      rescue  Stripe::AuthenticationError => e
        puts "Stripe Secret Key is not correct"
      end
    end
  end

end
