class Notifier < ActionMailer::Base
  default :from => "no-reply@qliqsoft.com"

  def sign_up_notification(user)
    @user = user
    mail(:to => "raviada@dobeyond.com;kkurapat@gmail.com", :subject => "New user signed up.")
  end

  def welcome_user(user)
    @user = user
    mail(:to => user.email, :subject => "Thank you for your interest in qliqCharge!")
  end

  def staff_added_notification(physician_group, billing_agency)
    @physician_group = physician_group
    mail(:to => billing_agency.user.email, :subject => "You have been added as a staff in qliqCharge!")
  end

  def physicians_password_reset_notification(user)
    @user = user
    @edit_user_password_url = edit_user_password_url(:initial => true, :reset_password_token => @user.reset_password_token)
    mail(:to => user.email, :subject => "You have been added as a physician in qliqCharge!")
  end

  def staffs_password_reset_notification(user, physician_group)
    @user = user
    @physician_group = physician_group
    @edit_user_password_url = edit_user_password_url(:initial => true, :reset_password_token => @user.reset_password_token)
    mail(:to => user.email, :subject => "You have been added as a staff in qliqCharge!")
  end

 def password_reset_notification(user)
    @user = user
    @edit_user_password_url = edit_user_password_url(:reset_password_token => @user.reset_password_token)
    mail(:to => user.email, :subject => "Your password reset link")
  end


end

