class CaptureCodesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :class => "Encounter", :only => [:new, :index]
  skip_load_and_authorize_resource :only => :icd
  autocomplete :icd, :description

  def index
    @captured_codes = []
    unless session[:encounters].nil?
      encounters = session[:encounters].values
      @captured_codes = Encounter.find(encounters)
    end
    respond_to do |format|
      format.js { render :partial => 'index' }
    end
  end

  def new
    @encounter = get_encounter
    if @encounter.nil?
      @encounter = Encounter.new
      @encounter.date_of_service = Date.today
      @encounter.physician = current_user.resource
    end
    load_capture_codes
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def create
    @encounter = Encounter.new
    @encounter.attributes = params[:encounter]
    

    respond_to do |format|
      if @encounter.validate_date_of_service(session) && @encounter.save
        if @encounter.patient_id.nil?
          if session[:encounters].nil? 
            session[:encounters] = {@encounter.date_of_service.strftime("%Y/%m/%d") => @encounter.reload.id} 
          else 
            session[:encounters] = session[:encounters].merge(@encounter.date_of_service.strftime("%Y/%m/%d") => @encounter.reload.id)  
          end
        end
        format.html { redirect_to activities_path } 
        format.js {
          if @encounter.patient_id.nil?
            render :partial => 'complete'
          else
            flash[:notice] = "Successfully Captured the code."
            render :js => "window.location='#{activities_path}'"
          end
        }
      else
        load_capture_codes
        format.js {
          render :partial => 'new'
        }

      end
    end
  end

  def edit
    @encounter = Encounter.for_dot(params[:id], params[:dot]).first 
    if @encounter.nil?
      @encounter = Encounter.new 
      @encounter.patient_id = params[:id]
      @encounter.date_of_service = params[:dot] 
      @encounter.physician = current_user.resource
    end
    load_capture_codes
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def update
    @encounter = Encounter.find(params[:id])
    @encounter.attributes = params[:encounter]
    check_if_removed(params[:encounter])
    respond_to do |format|
      if @encounter.save
        format.html { redirect_to activities_path } 
        format.js {
          if @encounter.patient_id.nil?
            render :partial => 'complete'
          else
            render :js => "window.location='#{activities_path}'"
          end
        }
      else
        load_capture_codes
        format.js {
          render :partial => 'new'
        }

      end
    end
  end

  def destroy
  end 

  def icd
    @icd = Icd.find(params[:id])
    @partial = params[:partial]
    respond_to do |format|
      format.js {
        render :partial => 'icd'
      }
    end
  end
  def autocomplete_icd_description
    term = params[:term]
    if term && !term.empty?
      icds = current_user.resource.physician_superbills.preferred.first.superbill.superbill_icds.collect(&:icd_id)
      icds = current_user.resource.favorite_icd_codes.collect(&:icd_id)  if icds.blank?
      if icds.empty?
        items = Icd.where(["LOWER(description) LIKE ?", "#{term.downcase}%"]) \
          .limit(10).order("description ASC")
      else
        items = Icd.where(["LOWER(description) LIKE ? and id in (?)", "#{term.downcase}%",  icds]) \
          .limit(10).order("description ASC")
      end
    else
      items = {}
    end
    render :json => json_for_autocomplete(items, :description)
  end
  private

  def load_capture_codes
    @max_columns = 0
    @capture_codes = {}
    capture_codes = PhysicianSuperbill.find_by_sql CAPTURE_CODES.to_s.gsub('local_physician_id', current_user.resource.id.to_s) 
    @cpt_groups = capture_codes.collect(&:cpt_group_name).uniq 
    @cpt_groups.each do |group_name|
      group_collection = capture_codes.select{|p| p.cpt_group_name == group_name}
      temp = {}
      temp[group_name] = {}
      counter = 0
      group_collection.each do |member|
        temp[group_name] = temp[group_name].merge(counter => {:cpt_code => member.cpt_code, :cpt_description => member.cpt_description, :superbill_cpt_id => member.superbill_cpt_id})
        counter += 1
      end
      @max_columns = counter if counter > @max_columns
      @capture_codes = @capture_codes.merge(temp)
    end
    load_physicians
    #load_icd_codes(capture_codes)
  end

  def load_icd_codes(capture_codes)
    @icd_codes = []
    icds = capture_codes.collect(&:icd_id).uniq.compact 
    if icds.empty?
      @icd_codes = current_user.resource.favorite_icd_codes
      if @icd_codes.empty?
        @icd_codes = ICD_CODES 
      end
    else
      @icd_codes = Icd.find(icds)
    end
  end

  def load_physicians
    @physicians = current_user.resource.group_id.nil? ?  current_user.resource.to_a : current_user.resource.physician_group.physicians
  end

  def check_if_removed(params)
    unless params["encounter_cpts_attributes"].nil?
      new_cpts = params["encounter_cpts_attributes"].keys
      old_cpts = @encounter.encounter_cpts.collect{|a| a.superbill_cpt_id.to_s}
      removed_cpts = old_cpts - new_cpts
      EncounterCpt.destroy_all(["encounter_id = ? and superbill_cpt_id in (?)", @encounter.id, removed_cpts]) unless removed_cpts.empty?
    end
    updated_icds = params["encounter_icds_attributes"].values
    new_icds = []
    updated_icds.each do |value|
      new_icds << value["icd_id"].to_i unless value["icd_id"].blank?
    end
    old_icds = @encounter.encounter_icds.collect(&:icd_id)
    removed_icds = old_icds - new_icds
    EncounterIcd.destroy_all(["encounter_id = ? and icd_id in (?)", @encounter.id, removed_icds]) unless removed_icds.empty?
  end
end
