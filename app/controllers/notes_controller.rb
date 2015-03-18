class NotesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  layout 'physician'
  uses_tiny_mce(:options => AppConfig.default_mce_options, :only => [:new, :edit])

  def index
    if params[:patient] #request coming from activites page with patient selected so no need to render patient list
      @notes = Note.get_notes(params[:patient].to_i)
      @patient = Patient.find(params[:patient])
    elsif params[:patient_id] #request coming from notes index[patient list] under NOTE TAB so we need to render patient list
      @notes = Note.get_notes(params[:patient_id].to_i)
      @patient = Patient.find(params[:patient_id])
      @flag = 1
    else  #request coming from activities index[NOTE TAB] so no params and we need to render patient list
      @notes = Note.get_notes(current_user.resource.patients.first)
      @patient = current_user.resource.patients.first
      @flag = 1
    end
    @patients = current_user.resource.patients if @flag
    respond_to do |format|
      format.html
    end
  end

  def show
    @note = Note.find(params[:id]) 
   respond_to do |format|
      format.html { render :layout => false }
    end
  end


  def new
    if params[:patient]
      @patient = Patient.find(params[:patient])
      encounter = get_encounter(params[:patient].to_i)
    else
      encounter = get_encounter
    end
    @flag = 1 if params[:flag]
    @note = note_for_encounter(encounter, params[:note].to_i)
    @note.type_id = params[:note].to_i if @note.type_id.nil?
    respond_to do |format|
      format.html { render :layout => false }
      format.js {render :partial => 'index'}
    end
  end

  def create
    @note = Note.new(params[:note])
    if params[:patient_id] 
      @patient = Patient.find(params[:patient_id])
      if DISCHARGED_NOTES.include?(@note.type_id.to_i) 
        hospital_episode = @patient.hospital_episodes.first
        hospital_episode.discharge_date = Date.today
        hospital_episode.save
      end
    end
    @flag = 1 if params[:flag]
    respond_to do |format|
      if @note.save
        encounter = @patient.nil? ? get_encounter : get_encounter(@patient.id)  
        unless encounter.nil? 
          encounter_note = encounter.encounter_notes.build
          if @patient 
            encounter.patient_id = @patient.id 
            encounter.save
          end
          encounter_note.note = @note
          encounter_note.save
        else
          @patient.nil? ? create_new_encounter_for_note(@note) : create_new_encounter_for_note(@note, @patient.id )  
        end

        if @patient 
          flash[:notice] = 'Note was successfully added.'
          if @flag#note is added from note index with patient list so need to render patient list
            format.js  { render :js => "window.location='#{notes_path(:patient_id => @patient.id)}'" }
          else#note is added from notes index BUT no need to render patient list 
            format.js  { render :js => "window.location='#{notes_path(:patient => @patient.id)}'" }
          end
        else #note is added from patient form
          format.js {
            render :partial => 'create' 
          }
        end
      else
        format.html { render :layout => false }
        format.js {
          render :partial => 'new'
        }
      end
    end
  end

  def edit
  end

  def update
    @note = Note.find(params[:id])
    @note.attributes = params[:note]
    respond_to do |format|
      if @note.save
        format.js {
          render :partial => 'create' 
        }
      else
        format.html { render :layout => false }
        format.js {
          render :partial => 'new'
        }
      end
    end end

  def destroy
  end 

  private

  def note_for_encounter(encounter, type )
    note = Note.new 
    if !encounter.nil? && !encounter.notes.empty?
      case type
      when ADMIT_NOTE 
        note = encounter.notes.admit_note.first unless encounter.notes.admit_note.empty?
      when HOSPITAL_COURSE 
        note = encounter.notes.hospital_course.first unless encounter.notes.hospital_course.empty?
      when MEDICATION 
        note = encounter.notes.medication.first unless encounter.notes.medication.empty?
      when FOLLOWUP_INSTRUCTION 
        note = encounter.notes.followup_instruction.first unless encounter.notes.followup_instruction.empty?
      end
    end
    return note
  end

  def create_new_encounter_for_note(note, patient=nil )
    encounter = Encounter.new
    encounter.date_of_service = Date.today
    encounter.physician_id = current_user.resource_id
    encounter.patient_id = patient unless patient.nil?
    encounter.save(false)

    encounter_note = EncounterNote.new
    encounter_note.encounter = encounter
    encounter_note.note = note
    encounter_note.save

    session[:encounters] = {encounter.date_of_service.strftime("%Y/%m/%d") => encounter.reload.id} if patient.nil?
  end

end
