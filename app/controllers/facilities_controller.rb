class FacilitiesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  layout 'admin'

  # GET /facilities
  # GET /facilities.xml
  def index
    @entity = current_user.resource
    if is_group_admin?
      @facilities = @entity.physician_grouip.group_facilities.where(:visible_to_group => true) | @entity.facilities.where(:visible_to_group => false)
    else
      @facilities = @entity.facilities
    end
    @facilities = @facilities.paginate(:per_page => 20, :page => params[:page])  
  
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @facilities }
    end
  end

  # GET /facilities/1
  # GET /facilities/1.xml
  def show
    @facility = Facility.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @facility }
    end
  end

  # GET /facilities/new
  # GET /facilities/new.xml
  def new
    @facility = Facility.new
    respond_to do |format|
      format.html { render :layout => false} 
    end
  end

  # GET /facilities/1/edit
  def edit
    @facility = Facility.find(params[:id])
    respond_to do |format|
      format.html { render :layout => false} 
    end
  end

  # POST /facilities
  # POST /facilities.xml
  def create
    @facility = Facility.new(params[:facility])
    @facility.resource = current_user.resource

    respond_to do |format|
      if @facility.save
        flash[:notice] = "Facility was successfully created."
        format.html { redirect_to(@facility) }
        format.js {
              render :js => "window.location='#{facilities_path}'"
        }
      else
        format.html { render :action => "new" }
        format.js {
          render :partial => 'new'
        }
      end
    end
  end

  # PUT /facilities/1
  # PUT /facilities/1.xml
  def update
    @facility = Facility.find(params[:id])
    @facility.resource = current_user.resource

    respond_to do |format|
      if @facility.update_attributes(params[:facility])
        flash[:notice] = "Facility was successfully updated."
        format.html { redirect_to(@facility) }
        format.js {
              render :js => "window.location='#{facilities_path}'"
        }
      else
        format.html { render :action => "edit" }
        format.js {
          render :partial => 'new'
        }
      end
    end
  end

  # DELETE /facilities/1
  # DELETE /facilities/1.xml
  def destroy
    @facility = Facility.find(params[:id])
    @facility.destroy

    respond_to do |format|
      format.html { redirect_to(facilities_url) }
      format.xml  { head :ok }
    end
  end
end

