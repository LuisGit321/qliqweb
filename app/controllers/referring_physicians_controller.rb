class ReferringPhysiciansController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  layout 'admin'
  before_filter :get_specialty, :except => [:index, :destroy, :show]

  # GET /referring_physicians
  # GET /referring_physicians.xml
  def index
    @entity = current_user.resource
    if is_group_admin?
      @referring_physicians = @entity.physician_group.referral_physicians.where(:visible_to_group => true) | @entity.referring_physicians.where(:visible_to_group => false)
    else
      @referring_physicians = @entity.referring_physicians
    end
    @referring_physicians = @referring_physicians.paginate(:per_page => 20, :page => params[:page])  
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @referring_physicians }
    end

  end

  # GET /referring_physicians/1
  # GET /referring_physicians/1.xml
  def show
    @referring_physician = ReferringPhysician.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @referring_physician }
    end
  end

  # GET /referring_physicians/new
  # GET /referring_physicians/new.xml
  def new
    @referring_physician = ReferringPhysician.new
    # This form will be rendered from multiple controllers so to get back to appropriate caller we are setting referrel url for back link
    @request_source = request.env["HTTP_REFERER"]
    @src = params[:new_referring]
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  # GET /referring_physicians/1/edit
  def edit
    @referring_physician = ReferringPhysician.find(params[:id])
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  # POST /referring_physicians
  # POST /referring_physicians.xml
  def create
    @request_source = request.env["HTTP_REFERER"]
    @src = params[:new_referring]
    @referring_physician = ReferringPhysician.new(params[:referring_physician])
    @referring_physician.resource = current_user.resource 
    respond_to do |format|
      if @referring_physician.save
        flash[:notice] = 'Referral Physician was successfully created.'
        format.html { redirect_to(@request_source) }
        format.js {
          unless current_user.resource.group_id.nil?
            @referring_physicians = current_user.resource.referring_physicians.private | current_user.resource.physician_group.referral_physicians.visible
          else
            @referring_physicians = current_user.resource.referring_physicians    
          end
          #render :js => "window.location='#{referring_physicians_path}'"
          if @src=="primary_referring"
            render :partial => '/patients/primary' 
          elsif @src=="secondary_referring" 
            render :partial => '/patients/secondary' 
          elsif (@src != "primary_referring" and @src != "secondary_referring")   
            render :js => "window.location='#{@request_source}'" 
          end
        }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @referring_physician.errors, :status => :unprocessable_entity }
        format.js {
          render :partial => 'new'
        }
      end
    end
  end

  # PUT /referring_physicians/1
  # PUT /referring_physicians/1.xml
  def update
    @referring_physician = ReferringPhysician.find(params[:id])
    @referring_physician.resource = current_user.resource 

    respond_to do |format|
      if @referring_physician.update_attributes(params[:referring_physician])
        flash[:notice] = 'Referral Physician was successfully updated.'
        format.html { redirect_to(@referring_physician) }
        format.js {
              render :js => "window.location='#{referring_physicians_path}'"
        }
      else
        format.html { render :action => "edit" }
        format.js {
          render :partial => 'new'
        }
      end
    end
  end

  # DELETE /referring_physicians/1
  # DELETE /referring_physicians/1.xml
  def destroy
    @referring_physician = ReferringPhysician.find(params[:id])
    @referring_physician.destroy

    respond_to do |format|
      format.html { redirect_to(referring_physicians_path) }
      format.xml  { head :ok }
    end
  end



end


