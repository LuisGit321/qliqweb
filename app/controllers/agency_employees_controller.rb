class AgencyEmployeesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :class => "AgencyEmployee"
  layout 'billing_agency' 
  
  def index
    @agency_employees = current_user.resource.agency_employees
     respond_to do |format|
       format.html # index.html.erb
     end
  end

  def show
  end

  def new
    @agency_employee = AgencyEmployee.new
    load_defaults
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def edit
    @agency_employee = AgencyEmployee.find(params[:id])
    @request_source = request.env["HTTP_REFERER"]
    respond_to do |format|
      format.html { render :layout => false if current_user.role?(ROLES[BILLING_ADMIN]) }
      
    end
  end

  def create
    @agency_employee = AgencyEmployee.new(params[:agency_employee])
    @agency_employee.user.roles = ROLES[BILLING_FUNCTIONAL].to_a
    @agency_employee.billing_agency_id = current_user.resource.id
    respond_to do |format|
      if @agency_employee.save
        flash[:notice] = 'Agency Employee was successfully created.'
        format.html { redirect_to(agency_employees_path) }  
        format.js {
          render :js => "window.location='#{agency_employees_path}'"
        }
      else 
        load_defaults
        format.html { render :action => "new" }
        format.js {
          render :partial => 'new'
        }
      end
    end
  end


  def update
    @request_source = request.env["HTTP_REFERER"]
    @agency_employee = AgencyEmployee.find(params[:id])
    @agency_employee.attributes = params[:agency_employee]
    respond_to do |format|
      if @agency_employee.save
        flash[:notice] = 'Agency Employee was successfully updated.'
        format.html { redirect_to(@request_source) }  
        format.js {
          render :js => "window.location='#{@request_source}'"
        }
      else 
        load_defaults
        format.html { render :action => "edit" }
        format.js {
          render :partial => 'new'
        }
      end
    end
  end


  def destroy
    @agency_employee = AgencyEmployee.find(params[:id])
    if @agency_employee.user.locked_at?
      @agency_employee.user.unlock_access!
    else
      @agency_employee.user.lock_access!
    end
    respond_to do |format|
      format.html { redirect_to(agency_employees_path) }
      format.js {
        render :js => "window.location='#{agency_employees_path}'"
      }

    end
  end

  def load_defaults
    @agency_employee.build_user if @agency_employee.user.nil?
  end

end
