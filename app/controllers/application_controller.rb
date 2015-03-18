class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :is_group_admin?, :current_cart

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Access denied."
    redirect_to root_url
  end

  def my_home_path(user)
    if user.role?(ROLES[SYSTEM_ADMIN])
      physician_groups_path
    elsif user.role?(ROLES[PHYSICIAN_FUNCTIONAL]) || user.role?(ROLES[PHYSICIAN_ADMIN])
      activities_path
    elsif  user.role?(ROLES[GROUP_ADMIN])
      providers_path
    elsif user.role?(ROLES[BILLING_ADMIN]) || user.role?(ROLES[BILLING_FUNCTIONAL])
      billing_agency_profile_path(current_user.resource)
    else
      '/'
    end
  end

  def get_entity
    @entity = nil
    if current_user.role?(ROLES[GROUP_ADMIN])
      @entity = current_user.resource
    end
  end

  def is_group_admin?(user = nil)
    user = current_user if user.nil?
    if user
      user.role?(ROLES[GROUP_ADMIN])
    else
      flash[:notice] = "Please log in to continue"
      redirect_to '/'
    end
  end

  def is_sys_admin?
    if current_user.role?(ROLES[SYSTEM_ADMIN])
      flash[:notice] = "You do not have sufficient privileges"
      redirect_to '/'
    end
  end

  def is_billing_admin?
    return current_user.role?(ROLES[BILLING_ADMIN])
  end

  def is_billing_functional?
    return current_user.role?(ROLES[BILLING_FUNCTIONAL])
  end

  def get_specialty
    @specialties = Specialty.all
  end

  def get_encounter(patient=nil)
    encounter = nil
    unless patient.nil?
      encounter = Encounter.for_dot(patient, Date.today.strftime("%Y-%m-%d")).first
    else
      unless session[:encounters].nil?
        date = Date.today.strftime("%Y/%m/%d")
        encounter = Encounter.find(session[:encounters][date]) if session[:encounters].keys.include?(date)
      end
    end
    return encounter
  end

  def start_date(date)
    date.blank? ? (Date.today - 1.year) : date
  end

  def end_date(date)
    date.blank? ? Date.today : date
  end

  def current_cart
    if session[:cart_id]
      @current_cart ||= Cart.find_by_id(session[:cart_id])
      session[:cart_id] = nil if @current_cart.nil? || (@current_cart && @current_cart.purchased_at)
    end
    if session[:cart_id].nil?
      @current_cart = Cart.create!
      session[:cart_id] = @current_cart.id
    end
    @current_cart
  end

  protected
  def authenticate_user!
    unless user_signed_in?
      flash[:error] = "Please login to continue"
      redirect_to root_url
    end
  end
end
