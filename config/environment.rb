# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
CCWebApp::Application.initialize!
ActionMailer::Base.delivery_method = :smtp
#ActionMailer::Base.perform_deliveries = true
#ActionMailer::Base.raise_delivery_errors = false
#ActionMailer::Base.default :charset => "utf-8"

#ActionMailer::Base.smtp_settings = {
#    #:tls => true,
#    :address => "smtp.gmail.com",
#    :port => "587",
#    :domain => "qliqsoft.com",
#    :authentication => :plain,
#    :user_name => "lorem.ipsume@gmail.com",
#    :password => "lorem123456"
#}

ActionMailer::Base.smtp_settings = {
 :address => "smtpout.secureserver.net",
 :port => 80,
 :domain => "www.qliqsoft.com",
 :authentication => :plain,
 :user_name => "no-reply@qliqsoft.com",
 :password => "lala@ku@lala"
}
