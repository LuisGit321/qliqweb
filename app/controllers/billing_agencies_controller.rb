require 'pdf_report'
class BillingAgenciesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  before_filter :get_billing_agency, :except => [:index, :new, :create, :destroy, :change_billing_agency, :edit, :update]
  layout 'billing_agency'

  # GET /billing_agencies
  # GET /billing_agencies.xml
  def index
    @billing_agencies = BillingAgency.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @billing_agencies }
    end
  end

  # GET /billing_agencies/1
  # GET /billing_agencies/1.xml
  def show
    @billing_agency = BillingAgency.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @billing_agency }
    end
  end

  # GET /billing_agencies/new
  # GET /billing_agencies/new.xml
  def new
    @billing_agency = BillingAgency.new
    @billing_agency.build_user
    load_defaults
    respond_to do |format|
      format.html { render :layout => false } 
    end
  end

  # GET /billing_agencies/1/edit
  def edit
    @billing_agency = BillingAgency.find(params[:id])
    load_defaults
    respond_to do |format|
      format.html { render :layout => false   } 
    end
  end

  # POST /billing_agencies
  # POST /billing_agencies.xml
  def create
    @billing_agency = BillingAgency.new(params[:billing_agency])
    @billing_agency.user.roles = ROLES[BILLING_ADMIN].to_a
    load_defaults
    respond_to do |format|
      if @billing_agency.save
        flash[:notice] = 'Billing agency was successfully created.'
        format.html { redirect_to(@billing_agency) }
        format.js {
              render :js => "window.location='#{billing_agencies_path}'"
        }
      else
        format.html { render :action => "new" }
        format.js {
          render :partial => 'new'
        }
      end
    end
  end

  # PUT /billing_agencies/1
  # PUT /billing_agencies/1.xml
  def update
    load_defaults
    @billing_agency = BillingAgency.find(params[:id])
    @billing_agency.attributes = params[:billing_agency]
    flag = @billing_agency.user.email_changed? ? true : false

    respond_to do |format|
      if @billing_agency.save
        @billing_agency.user.reset_email if flag 
        flash[:notice] = 'Billing agency was successfully updated.'
        format.html { redirect_to(@request_source) }
        format.xml  { head :ok }
        format.js {
              render :js => "window.location='#{@request_source}'"
        }
      else
        load_defaults
        format.html { render :action => "edit" }
        format.xml  { render :xml => @billing_agency.errors, :status => :unprocessable_entity }
        format.js {
          render :partial => 'new'
        }
      end
    end
  end

  # DELETE /billing_agencies/1
  # DELETE /billing_agencies/1.xml
  def destroy
    @billing_agency = BillingAgency.find(params[:id])
    @billing_agency.destroy

    respond_to do |format|
      format.html { redirect_to(billing_agencies_url) }
      format.xml  { head :ok }
    end
  end

  def change_billing_agency
    @billing_agency = BillingAgency.find(params[:billing_agency_id])
    respond_to do |format|
    #   format.html {render :action => "show" }
       format.js {
         render :partial => 'show'
       }
    end
  end
 
  def profile
    load_report_defaults
    @billing_patient = BillingPatient.new
  end

  def search
    load_report_defaults
    @billing_patient = BillingPatient.new(params[:billing_patient])
    load_patients(@billing_patient) 
    flash[:notice] =  "No data available" if @patients.empty?
    respond_to do |format|
      format.html { render :action => :profile   } 
    end
  end

  def report
    load_report_defaults
    @billing_patient = BillingPatient.new(params[:billing_patient])
    load_patients(@billing_patient) 
    if @patients.empty?
      flash[:notice] =  "No data available"
      respond_to do |format|
        format.html { render :action => :profile   } 
      end
    elsif params[:commit] == "Export Selected to PDF"   
      if !params[:select_all]
        patients_list = Patient.find(params[:patients]).collect(&:id)            
      else
        patients_list = @patients.collect(&:id)
      end
      directory = RAILS_ROOT + "/public/system/reports"
      Dir.mkdir( directory ) unless File.exists?( directory )
      filename= PdfReport.generate_billing_agency_report(@patients, @billing_agency.id, @billing_agency.name, patients_list)
      send_file RAILS_ROOT + "/public/system/reports/#{filename}"
      save_report_information(filename)
      generate_report(params) if params[:patients]
    elsif params[:print_report] == "1"
      @patients = Patient.find(params[:patients])
      respond_to do |format|
        format.html { render :layout => false   } 
      end
    else
      respond_to do |format|
        format.html { render :action => :profile   } 
      end
    end
  end

  def physicians
    if params[:group_id].blank? 
      @physicians = Physician.by_billing_agency(@billing_agency.id)
    else
      group = PhysicianGroup.find(params[:group_id])
      @physicians = Physician.physicians_billing_agency(@billing_agency.id, group.physicians.collect(&:id))
    end
    respond_to do |format|
      format.js { render :partial =>  'physicians' } 
    end
  end

  def history
    load_report_defaults
    @billing_patient = params[:billing_patient].blank? ? BillingPatient.new : BillingPatient.new(params[:billing_patient])
    get_billing_history
  end

  def load_defaults
    @request_source = request.env["HTTP_REFERER"]
  end

  def load_report_defaults
    @groups = PhysicianGroup.by_billing_agency(@billing_agency.id)
    @physicians = []#Physician.by_billing_agency(@billing_agency.id)
    @patients = []
  end

  def load_patients(billing_patient)
    if billing_patient.group.blank? && billing_patient.physician.blank?
      @patients = Patient.joins(:encounters, :physician).where("encounter.processed_date is NULL and (physician.id in (?) or physician.group_id in (?))", @groups.collect(&:id), @physicians.collect(&:id))
    elsif !billing_patient.group.blank? && billing_patient.physician.blank?
      @patients = Patient.joins(:encounters, :physician).where("encounter.processed_date is NULL and physician.group_id = ?", billing_patient.group)
    elsif billing_patient.group.blank? && !billing_patient.physician.blank?
      @patients = Patient.joins(:encounters, :physician).where("encounter.processed_date is NULL and physician.id = ?", billing_patient.physician)
    else
      @patients = Patient.joins(:encounters, :physician).where("encounter.processed_date is NULL and physician.id = ? and physician.group_id = ?", billing_patient.physician, billing_patient.group)
    end
    @patients = @patients.uniq
  end

  def generate_report(params)
    params[:patients].each do |patient_id|
      Encounter.update_all ["processed_date = ?", Date.today], ["id in (?)", params[:encounters][patient_id.to_s]]
    end
  end

  def save_report_information(file)
    report = BillingReport.new
    report.processed_date = Date.today
    report.user = current_user
    report.group = @billing_patient.group.blank? ? "All" : PhysicianGroup.find(@billing_patient.group).name
    report.physician = @billing_patient.physician.blank? ? "All" : Physician.find(@billing_patient.physician).name
    report.report_path = file
    report.save
  end

  def get_billing_agency
    if current_user.roles.include?(ROLES[BILLING_ADMIN])
      @billing_agency = current_user.resource
    else
      @billing_agency = current_user.resource.billing_agency
    end
  end

  def get_billing_history
    billing_users = []
    billing_users << @billing_agency.user.id
    billing_users << @billing_agency.agency_users.collect(&:id)
    billing_users = billing_users.flatten
    if @billing_patient.group.nil? && @billing_patient.physician.nil?
      @history = BillingReport.where("user_id in (?)", billing_users)
    elsif !@billing_patient.group.nil? && @billing_patient.physician.nil?
      @history = BillingReport.where("user_id in (?) and \"group\" = ?", billing_users, PhysicianGroup.find(@billing_patient.group).name)
    elsif @billing_patient.group.nil? && !@billing_patient.physician.nil?
      @history = BillingReport.where("user_id in (?) and physician = ?", billing_users, Physician.find(@billing_patient.physician).name)
    else
      @history = BillingReport.where("user_id in (?) and \"group\" = ? and physician = ?", billing_users, PhysicianGroup.find(@billing_patient.group).name, Physician.find(@billing_patient.physician).name)
    end
  end
end
