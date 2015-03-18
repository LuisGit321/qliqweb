class PhysicianGroupsController < ApplicationController
  #before_filter :authenticate_user!, :only => [:edit, :update]
  #load_and_authorize_resource
  #before_filter :get_entity
  before_filter :is_owner?, :only => [:edit, :update]
  before_filter :check_if_paid, :only => [:edit, :update]

  layout 'admin'

  # GET /physician_groups
  # GET /physician_groups.xml
  def index
    @physician_groups = PhysicianGroup.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @physician_groups }
    end
  end

  # GET /physician_groups/1
  # GET /physician_groups/1.xml
  def show
    @physician_group = PhysicianGroup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @physician_group }
    end
  end

  # GET /physician_groups/new
  # GET /physician_groups/new.xml
  def new
    @physician_group = PhysicianGroup.new
    @physician_group.build_billing_pref
    respond_to do |format|
      format.html { render :layout => false }
      format.xml { render :xml => @physician_group }
    end
  end

  # GET /physician_groups/1/edit
  def edit
    (@physician_group.providers-@physician_group.physicians.size).times { @physician_group.physicians.build { |p| p.build_user } }
    1.times { @physician_group.billing_agencies.build { |p| p.build_user } }
    render :layout => 'subscribe'
  end

  # POST /physician_groups
  # POST /physician_groups.xml
  def create
    raise  @physician_group.inspect
    @physician_group = PhysicianGroup.new(params[:physician_group])
    respond_to do |format|
      if @physician_group.save
        flash[:notice] = 'Physician group was successfully created.'
        format.html { redirect_to(physician_groups_path) }
        format.xml { render :xml => @physician_group, :status => :created, :location => @physician_group }
        format.js {
          render :js => "window.location='#{physician_groups_path}'"
        }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @physician_group.errors, :status => :unprocessable_entity }
        format.js {
          render :partial => 'new'
        }
      end
    end
  end

  # PUT /physician_groups/1
  # PUT /physician_groups/1.xml
  def update
    attributes = params
    params = filter_billing_attributes(attributes)
    @physician_group.attributes = params[:physician_group]
    respond_to do |format|
      if @physician_group.save
        sign_in @physician_group.user unless current_user

        system "rake mass_password_reset_link[#{@physician_group.id}] RAILS_ENV=#{Rails.env} --trace 2>&1 >> #{Rails.root}/log/rake.log &"

        flash[:notice] = 'Physician group was successfully updated.'
        format.html { redirect_to providers_path }
        format.js {
          if @entity.nil?
            render :js => "window.location='#{physician_groups_path}'"
          else
            render :js => "window.location='#{edit_physician_group_path}'"
          end
        }
      else
        format.html { render :action => "edit", :layout => 'subscribe' }

        format.xml { render :xml => @physician_group.errors, :status => :unprocessable_entity }
        format.js {
          render :partial => 'new'
        }
      end
    end
  end

  # DELETE /physician_groups/1
  # DELETE /physician_groups/1.xml
  def destroy
    @physician_group = PhysicianGroup.find(params[:id])
    @physician_group.destroy
    respond_to do |format|
      format.html { redirect_to(physician_groups_url) }
      format.xml { head :ok }
    end
  end

  def change_agency
    billing_agency = BillingAgency.find(params[:physician_group][:billing_agency_id])
    billing_pref = is_group_admin? ? current_user.resource.physician_group.billing_pref : current_user.resource.billing_pref
    billing_pref.billing_agency = billing_agency
    billing_pref.save
    flash[:notice] = 'Billing agency was successfully changed.'
    redirect_to billing_agency_path(billing_agency)
  end

  def filter_billing_attributes(params)
    billing_params = params[:physician_group][:billing_agencies_attributes] || []
    billing_params.each do |key, val|
      unless (billing_params[key]["user_attributes"]["email"].blank? && billing_params[key]["first_name"].blank? && billing_params[key]["last_name"].blank?)
        email = billing_params[key]["user_attributes"]["email"]
        agency = BillingAgency.joins(:user).where("users.email" => email)
        unless agency.empty?
          params = add_billing_pref_attributes(agency.first.id, @physician_group.id, params)
          params[:physician_group][:billing_agencies_attributes].delete(key)
        end
      end
    end if !billing_params.empty?
    return params
  end

  def add_billing_pref_attributes(agency_id, physician_group_id, params)
    unless params[:physician_group][:billing_prefs_attributes].nil?
      params[:physician_group][:billing_prefs_attributes] = params[:physician_group][:billing_prefs_attributes].merge("#{rand(1000)}" => {"billing_agency_id" => agency_id, "physician_group_id" => physician_group_id, "is_billing_exists" => "true"})
    else
      params[:physician_group] = params[:physician_group].merge("billing_prefs_attributes" => {"#{rand(1000)}" => {"billing_agency_id" => agency_id, "physician_group_id" => physician_group_id, "is_billing_exists" => "true"}})
    end
    return params
  end

  private

  def is_owner?
    @user = current_user || User.find(session[:user_id])
    @physician_group = @user.resource
  end

  def check_if_paid
    unless @physician_group.paid?

      flash[:error] = 'Payment is pending'
      redirect_to new_subscribe_path
      return false
    end
    true
  end

end


