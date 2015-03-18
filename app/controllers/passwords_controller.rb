class PasswordsController < Devise::PasswordsController
  layout false

  def create
    self.resource = resource_class.send_reset_password_instructions(params[resource_name])
    if resource.errors.empty?
      set_flash_message :notice, :send_instructions
      redirect_to root_path
    else
      set_flash_message :notice, :invalid_email
      redirect_to root_path
    end
  end

  def update
    super
    if resource.errors.empty?
      resource.set_user_sip_config
      Subscriber.initial_setup_sip_subscriber(resource)
    end
  end
end
