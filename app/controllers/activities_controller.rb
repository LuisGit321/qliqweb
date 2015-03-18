class ActivitiesController < ApplicationController
  before_filter :authenticate_user!
  layout 'physician'
  def index
    @patients = current_user.resource.patients.ordered# - current_user.resource.patients.discharged.uniq
  end

  def history
    @report = Report.new
    @patients = [] 
  end

  def create
    @report = Report.new(params[:report])
    if @report.valid?
      @patients = Patient.by_date(@report.start_date, @report.end_date).uniq
    else
      @patients = [] 
    end
    respond_to do |format|
      format.html {render :action => 'history'}
    end
  end

  def billing
    @billings = Encounter.physician_billings(current_user.resource.id)
  end
end
