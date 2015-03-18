class PatientsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  layout 'physician'

  def index
    render :layout => false
  end

  def new
    @patient = Patient.new
    @patient.facility = current_user.resource.physician_pref.try(:facility)
    @request_source = request.env["HTTP_REFERER"]
    load_defaults
    unless session[:encounters].nil?
      encounters = session[:encounters]
      # set the patient_id
      Encounter.destroy(encounters.values)
      # clear the session
      session[:encounters] = nil
    end
    respond_to do |format|
      format.html  
    end
  end

  def create
    @patient = Patient.new(params[:patient])
    @patient.physician_id = current_user.resource_id 
    respond_to do |format|
      if @patient.save
        # Get the Encounters stored in the session
        unless session[:encounters].nil?
          encounters = session[:encounters]
          encounters.values.each do |encounter_id|
            # set the patient_id
            encounter = Encounter.find(encounter_id)
            encounter.patient = @patient.reload
            encounter.save(false)
          end
          # clear the session
          session[:encounters] = nil
        end
        flash[:notice] = 'Patient was successfully created.'
        format.html { redirect_to(activities_path) }
        format.js {
          render :js => "window.location='#{activities_path}'"
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

  def edit
    @patient = Patient.find(params[:id])
    load_defaults
    respond_to do |format|
      format.html  
    end
  end

  def update
    @patient = Patient.find(params[:id])
    @patient.attributes = params[:patient]
    respond_to do |format|
      if @patient.save
        flash[:notice] = 'Patient was successfully updated.'
        format.html { redirect_to(activities_path) }
        format.js {
          render :js => "window.location='#{activities_path}'"
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
  end 

  def load_defaults
    unless current_user.resource.group_id.nil?  
      # @facilities = current_user.resource.facilities.private | current_user.resource.physician_group.group_facilities.visible
      @referring_physicians = current_user.resource.referring_physicians.private | current_user.resource.physician_group.referral_physicians.visible
    else
      # @facilities = current_user.resource.facilities
      @referring_physicians = current_user.resource.referring_physicians
    end
    @facilities = Facility.all
    @patient.hospital_episodes.build if @patient.hospital_episodes.empty?
  end
end
