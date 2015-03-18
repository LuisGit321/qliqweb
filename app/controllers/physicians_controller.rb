class PhysiciansController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  before_filter :get_entity, :except => [:change_billing_agency]
  before_filter :get_specialty, :except => [:index, :destroy, :show, :change_billing_agency]
  layout 'admin'

  # GET /physicians
  # GET /physicians.xml
  def index
    @physicians = @entity.nil? ? Physician.all : @entity.physicians
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @physicians }
    end
  end

  # GET /physicians/1
  # GET /physicians/1.xml
  def show
    @physician = Physician.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @physician }
    end
  end

  # GET /physicians/new
  # GET /physicians/new.xml
  def new
    @physician = Physician.new

    # This form will be rendered from multiple controllers so to get back to appropriate caller we are setting referrel url for back link
    @request_source = request.env["HTTP_REFERER"] 
    load_defaults
    respond_to do |format|
      format.html { render :layout => false } 
      format.xml  { render :xml => @physician }
      #format.json { render :json => @physician.validations_to_json(:name, "user.email") }
    end
  end

  # GET /physicians/1/edit
  def edit
    @physician = Physician.find(params[:id])
    @preferred_superbill = @physician.physician_superbills.preferred.first.try(:superbill_id)
    @superbill2 = @physician.physician_superbills.where(:preferred => nil).first.try(:superbill_id)
    load_defaults
    respond_to do |format|
      format.html { render :layout => false } 
      format.xml  { render :xml => @physician }
    end
  end

  # POST /physicians
  # POST /physicians.xml
  def create
    @physician = Physician.new(params[:physician])
    @physician.group_id = current_user.resource.id if is_group_admin?
    check_if_superbill_changed(params)  
    validate_billing_agency
    respond_to do |format|
     if @physician.save
        flash[:notice] = 'Physician was successfully created.'
        format.html { redirect_to(@request_source) }
        format.xml  { render :xml => @physician, :status => :created, :location => @physician }
        format.js {
              render :js => "window.location='#{@request_source}'"
        }
      else
        load_defaults
        format.html { render :action => "new" }
        format.xml  { render :xml => @physician.errors, :status => :unprocessable_entity }
        format.js {
          render :partial => 'new'
        }
      end
    end
  end

  # PUT /physicians/1
  # PUT /physicians/1.xml
  def update
    @physician = Physician.find(params[:id])
    @physician.attributes = params[:physician]
    @physician.user.roles = [] if params[:physician][:user_attributes][:roles].blank?
    flag = @physician.user.email_changed? ? true : false
    check_if_superbill_changed(params)  
   # validate_billing_agency
    respond_to do |format|
      if @physician.save 
        @physician.user.reset_email if flag 
        flash[:notice] = 'Physician was successfully updated.'
        format.html { redirect_to(@request_source) }
        format.xml  { head :ok }
        format.js {
              render :js => "window.location='#{@request_source}'"
        }
      else
        load_defaults
        format.html { render :action => "edit" }
        format.xml  { render :xml => @physician.errors, :status => :unprocessable_entity }
        format.js {
          render :partial => 'new'
        }
      end
    end
  end

  # DELETE /physicians/1
  # DELETE /physicians/1.xml
  def destroy
    @physician = Physician.find(params[:id])
    @physician.destroy

    respond_to do |format|
      format.html { redirect_to(physicians_url) }
      format.xml  { head :ok }
    end
  end

  def photo
    @resource = params[:for] == PHYSICIAN ? current_user.resource : current_user.resource
  end

  def upload
    @resource = params[:for].constantize.find(params[:physician_id])
    @print = Print.new
    @print.image = params[:image]
    @print.user = current_user
    if @print.save
      @resource.print = @print
      @resource.save
      redirect_to physician_photo_path(@resource, :for => params[:for] == "Physician" ? PHYSICIAN : HOSPITAL)
    else
      render :action => "photo" 
    end
  end

  def change_billing_agency
    @billing_agency = params[:group_id].blank? ? "" : PhysicianGroup.find(params[:group_id]).billing_pref.billing_agency.id
    respond_to do |format|
      format.js {
         render :partial => 'change'
      }
    end
  end

  private

  def validate_billing_agency
    @physician.billing_pref = nil if (!@physician.group_id.nil? && params[:physician][:billing_pref_attributes].blank?)
  end

  def load_defaults
    @groups = PhysicianGroup.all
    @superbills = Superbill.all
    @request_source = request.env["HTTP_REFERER"] 

    if current_user.role?(ROLES[SYSTEM_ADMIN])  
      @facilities = Facility.all 
    elsif  current_user.role?(ROLES[GROUP_ADMIN])  
      @facilities  = current_user.resource.group_facilities 
    else 
      @facilities = current_user.resource.facilities 
    end
=begin
    if @physician.billing_pref.nil?
      @physician.build_billing_pref 
      @physician.billing_pref.billing_agency = current_user.resource.billing_pref.billing_agency if is_group_admin? and !current_user.resource.billing_pref.nil? 
    end
=end
    if @physician.user.nil?
      @physician.build_user 
      @physician.user.roles = [ROLES[PHYSICIAN_FUNCTIONAL], ROLES[PHYSICIAN_ADMIN]] 
    end
    @physician.build_physician_pref if @physician.physician_pref.nil?
  end

  def check_if_superbill_changed(params)
    unless params[:superbill].blank?
      pref_superbill = @physician.physician_superbills.preferred.first
      if pref_superbill.nil?
        pref_superbill = @physician.physician_superbills.build 
        pref_superbill.preferred = 1
        pref_superbill.superbill_id = params[:superbill].to_i
      else
        pref_superbill.superbill_id = params[:superbill].to_i
        pref_superbill.save
      end
      @preferred_superbill = params[:superbill] 
    else
      if @physician.physician_superbills.preferred.first  
        @physician.physician_superbills.preferred.first.destroy  
      end
    end   

    unless params[:superbill2].blank?
      pref_superbill = @physician.physician_superbills.where(:preferred => nil).first
      if pref_superbill.nil?
        pref_superbill = @physician.physician_superbills.build 
        pref_superbill.superbill_id = params[:superbill2].to_i
      else
        pref_superbill.superbill_id = params[:superbill2].to_i
        pref_superbill.save
      end
      @superbill2 = params[:superbill2] 
    else
      unless @physician.physician_superbills.where(:preferred => nil).first.nil?
        @physician.physician_superbills.where(:preferred => nil).first.destroy
      end
    end
  end

end
