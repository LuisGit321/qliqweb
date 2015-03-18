class Registration < ActiveRecord::Base
  validates :name, :presence => {:message => "Please enter your name" }
  validates :email, :format => {:message => "Please enter valid email address", :with => Devise.email_regexp}

  after_save :send_notification

  def send_notification
    Notifier.sign_up_notification(self).deliver
    Notifier.welcome_user(self).deliver
  end
end
