require 'pdf_report'
class ReportsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource 
  layout 'physician'
  autocomplete :physician, :name

  def index
    @report = Report.new
    @patients = []
    load_physicians
    respond_to do |format| 
      format.html
    end
  end

  def create
    @report = Report.new(params[:report])  
    load_physicians
    @report.activity_log = true 
    unless @report.valid? # show error
      @patients = []
      physician = current_user.resource
      respond_to do |format| 
        format.html {    render :action => 'index' }
      end
    else
      physician = Physician.find(@report.physician_id)
      @patients = physician.patients
      get_hash(@report.start_date, @report.end_date)
      unless @hash.empty?      
        if params[:commit_id] == "html"  # generate html report
          respond_to do |format| 
            format.html {    render :action => 'index' }
          end
        elsif params[:commit_id] == "pdf" # generate pdf report
          pdf =  PdfReport.generate_activity_log_report(physician, @patients, @hash, @report.start_date, @report.end_date)  
          send_data(pdf.render ,:type => 'application/pdf', :filename => "actvity_log_report-#{Date.today.strftime("%Y-%m-%d")}.pdf", :disposition=> "attachment")
        elsif params[:commit_id] == "excel" # generate csv report
          csv_string = CsvReport.generate_activity_log_report(physician, @patients, @hash, @report.start_date, @report.end_date) 
          filename = "activity_log_report.csv" 
          send_data(csv_string, :type => 'text/csv; charset=utf-8; header=present', :filename => filename)
        end
      else
        flash[:notice] = 'No data available.'
        respond_to do |format| 
          format.html {    render :action => 'index' }
        end
      end
    end
  end

  def referral_volume
    @report = Report.new
    get_referring_physicians
    respond_to do |format| 
      format.html 
    end

  end

  def referral_volume_report
    @report = Report.new(params[:report])
    @records = nil
    get_referring_physicians
    if @report.valid?
      if @report.referring_physician_id.blank? 
        id = @referring_physicians.collect(&:id)
      else
        referring_physician =  ReferringPhysician.find(@report.referring_physician_id)
        id = referring_physician.id.to_a
      end
      get_referal_volume(id, @report.start_date, @report.end_date)
      if  @records.first.nil?
        flash[:notice] = 'No data available.'
        @records = nil
        respond_to do |format| 
          format.html { render :action => 'referral_volume' } 
        end
      else
        if params[:commit_id] == "html"
          respond_to do |format| 
            format.html { render :action => 'referral_volume' } 
          end
        elsif params[:commit_id] == "pdf"
          pdf =  PdfReport.generate_referral_volume_report(@records, @flag, @report.start_date, @report.end_date)
          send_data(pdf.render ,:type => 'application/pdf', :filename =>  "referral_volume_report.pdf", :disposition=> "attachment")
        elsif params[:commit_id] == "excel"
          records = @records   
          flag = @flag
          csv_string = CsvReport.generate_referral_volume_report(records, flag) 
          filename = "referral_volume_report.csv" 
          send_data(csv_string, :type => 'text/csv; charset=utf-8; header=present', :filename => filename)
        end
      end  
    else
      respond_to do |format| 
        format.html { render :action => 'referral_volume' } 
      end
    end
  end


  def get_referring_physicians
    unless current_user.resource.group_id.nil?
      @referring_physicians = current_user.resource.referring_physicians.private | current_user.resource.physician_group.referral_physicians.visible
    else
      @referring_physicians = current_user.resource.referring_physicians
    end
  end

  def get_referal_volume(physician_id, start_date, end_date)
    end_date = end_date.to_s.gsub('/', '-')
    start_date = start_date.to_s.gsub('/', '-') 
    @flag = 0 #to show all records
    @records =  HospitalEpisode.referral_volume(physician_id, start_date, end_date)
    unless  @report.referring_physician_id.blank? 
      @flag = 1 # to show specific record
      @records = @records.select{ |a| a.rid == @report.referring_physician_id }
    end 
  end

  def list
    @report = Report.new
    @result = {} 
    load_physicians
  end

  def generate
    load_physicians
    @report = Report.new(params[:report])
    @result = ActiveSupport::OrderedHash.new
    if @report.valid?
      physicians = @report.physician_id.blank? ? @physicians.collect(&:id) : @report.physician_id.to_a
      encounters = Encounter.monthly_encounters(physicians, @report.start_date, @report.end_date)
      patients = Patient.monthly_patients(physicians, @report.start_date, @report.end_date)
      patients.each do |patient|
        @result[Date::MONTHNAMES[patient.month.to_i]] = get_avg_stay(patient, encounters) 
      end 
      if @result.empty?
        flash[:notice] = "No data available"
        respond_to do |format|
          format.html { render :action => 'list'}
        end
      else
        if params[:commit_id] == "html"
          respond_to do |format|
            format.html { render :action => 'list'}
          end
        elsif params[:commit_id] == "pdf"
          pdf =  PdfReport.generate_average_length_of_stay_report(@result, @report.start_date, @report.end_date)
          send_data(pdf.render ,:type => 'application/pdf', :filename =>  "average_length_of_stay_report.pdf", :disposition=> "attachment")
        elsif params[:commit_id] == "excel"
          result = @result   
          csv_string = CsvReport.generate_average_length_of_stay_report(result) 
          filename = "average_length_of_stay_report.csv" 
          send_data(csv_string, :type => 'text/csv; charset=utf-8; header=present', :filename => filename)
        end
      end
    else
      respond_to do |format|
        format.html { render :action => 'list'}
      end
    end
  end


  def load_physicians
    @physicians = current_user.resource.group_id.nil? ?  current_user.resource.to_a : current_user.resource.physician_group.physicians
  end


  def autocomplete_physician_name
    term = params[:term]
    if term && !term.empty?
      unless current_user.resource.group_id.nil?
        items = Physician.where(["LOWER(name) LIKE ? and group_id = ?", "%#{term.downcase}%",  current_user.resource.group_id]) \
          .limit(10).order("name ASC")
      else
        items = Physician.where(["LOWER(name) LIKE ? and physician_id = ?", "%#{term.downcase}%",  current_user.resource.id]) \
          .limit(10).order("name ASC")
      end
    else
      items = {}
    end
    render :json => json_for_autocomplete(items, :name)
  end



  def get_hash(start_date, end_date)
    @hash = Hash.new
    @patients.each do |patient|
      patient.encounters.each do |encounter|
        if !encounter.cpts.empty? or !encounter.encounter_icds.empty? 
          if encounter.date_of_service >= start_date and  encounter.date_of_service <= end_date  
            @hash = @hash.merge( patient.id => {} ) unless @hash[patient.id]
            @hash[patient.id] =@hash[patient.id].merge(encounter.date_of_service.strftime("%Y/%m/%d") => {} )
            encounter.cpts.each do |cpts|
              @hash[patient.id][encounter.date_of_service.strftime("%Y/%m/%d")] =  @hash[patient.id][encounter.date_of_service.strftime("%Y/%m/%d")].merge( cpts.cpt_id => {:code => cpts.cpt.code, :description => cpts.cpt.description  } )
            end
            encounter.encounter_icds.each do |icds|
              @hash[patient.id][encounter.date_of_service.strftime("%Y/%m/%d")] =  @hash[patient.id][encounter.date_of_service.strftime("%Y/%m/%d")].merge( icds.icd_id => { :code => icds.icd.code, :description => icds.icd.description  } )
            end
          end
        end
      end
    end 
  end

  def get_avg_stay(patient, encounters)
    encounter = encounters.select{|a| a.month == patient.month}
    encounter.empty? ? "0" : (encounter.first.counts.to_i/ patient.counts.to_i)
  end

end
