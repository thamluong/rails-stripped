require "rails_helper"

describe UserMailer, :type => :mailer do
  it 'has from@your-domain.com as the from email address'
  it 'has user email as the to email address'
  it 'has Payment to RubyPlus Failed as the subject of the email'  
  it 'has link to edit credit card url in the email'
end