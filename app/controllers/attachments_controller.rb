class AttachmentsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create
  respond_to :html, :js
  def manage
    resource = params[:media]
    @attachments = "#{params[:media]}".classify.constantize.for_user(current_user.id).paginate :page => params[:page], :order => 'created_at DESC', :per_page => 10
    respond_with @attachments
  end



  def create
    @attachment = "#{params[:media]}".classify.constantize.new(params[params[:media]])
    @attachment.user = current_user
    if @attachment.save
      GC.start
    end
    responds_to_parent do
      render :file => "#{RAILS_ROOT}/app/views/attachments/create.js.erb", :content_type => 'application/js' 
    end
  end
end
