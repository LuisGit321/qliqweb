class ProvidersController < ApplicationController
  before_filter :authenticate_user!
  layout 'admin'

  def index
    @resources = params[:for].blank? ? current_user.resource.physicians : current_user.resource.billing_agencies
  end

  def new
    @for = params[:for]
    group = current_user.resource
    @resource = params[:for].blank? ? group.physicians.build{|p| p.build_user} : group.billing_agencies.build{|b| b.build_user}
    render :layout => false
  end

  def create
    @for = params[:for]
    group = current_user.resource
    if params[:for].blank? 
      @resource = group.physicians.build(params[:physician]) 
    else 
      @resource = group.billing_agencies.build(params[:billing_agency])
    end

    respond_to do |format|
      if @resource.save
        BillingPref.create(:physician_group_id => group.id, :billing_agency_id => @resource.reload.id) unless params[:for].blank?
        format.js {
          render :js => "window.location='#{providers_path(:for => @for)}'"
        }
      else
        format.js {
          render :partial => 'new'
        }
      end
    end
  end
end
