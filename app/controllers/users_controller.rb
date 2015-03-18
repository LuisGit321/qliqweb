class UsersController < Devise::ConfirmationsController
  def show
    user = User.find_by_confirmation_token(params[:confirmation_token])
    if user.nil?
      redirect_to '/'  and return 
    elsif user.errors.empty?
      if !user.last_sign_in_at.nil? && user.confirmed_at.nil?
        if user.confirm! # confirm the user with the token
          sign_in user # sign in the current user
          redirect_to my_home_path(user) and return
        end
      else
        if user.confirm!
          Subscriber.setup_sip_info(user) 
          if user.resource_type == "PhysicianGroup"
            sign_in user
            redirect_to my_home_path(user) and return
          else
            redirect_to reset_password_path(user, :attempt => 1) and return
          end
        end
      end
    end
    render :action => :new
  end

end
