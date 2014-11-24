
desc 'Send email reminder to customers if credit card is about to expire'
namespace :stripe do

  task :cc_expiration_reminder => :environment do
    today = DateTime.now
    checker = today + 30.days
    
    cards = CreditCard.where(expiration_year: Date.today.year)
    cards.each do |card|
      # Assume 1, since we don't capture the day.
      expiration_date = DateTime.new(card.expiration_year, card.expiration_month, 1)  
      if checker > expiration_date
        user = User.where(user_id: card.user_id).first
        # Send an email reminder to update credit card expiration date. The message is same as subscription payment failed.
        UserMailer.subscription_payment_failed(user).deliver_now
        # TODO : Mark reminder email has been sent to avoid sending emails everyday to the same user.
      else
        puts "Card : #{card.inspect} is not about to expire"
        puts "Expiration date is : #{expiration_date}"
        puts "Checker is : #{checker}"
      end
    end
  end

end