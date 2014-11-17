Rails.configuration.stripe = {
  publishable_key: ENV['STRIPE_PUBLISHABLE_KEY'],
  secret_key:      ENV['STRIPE_SECRET_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
STRIPE_PUBLIC_KEY = Rails.configuration.stripe[:publishable_key]

# Create a logger which ages the log file once it reaches a certain size. 
# Leave 10 old log files where each file is about 1,024,000 bytes.
StripeLogger = Logger.new("#{Rails.root}/log/stripe.log", 10, 1024000)