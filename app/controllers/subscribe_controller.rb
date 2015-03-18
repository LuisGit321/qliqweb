class SubscribeController < ApplicationController
  before_filter :set_entity, :only => [:show, :billing_information, :create_billing_info, :edit, :update, :edit_billing_information, :update_billing_info]

  layout 'subscribe'

  def index
    @user = ProspectiveSubscriber.new
    @user.build_physician_group
    render :action => :new, :layout => 'home'
  end

  def create
    @user = ProspectiveSubscriber.new(params[:prospective_subscriber])
    @user.passed_step = 1
    respond_to do |format|
      if @user.save
        session[:prospective_subscriber_id] = @user.id
        LineItem.clear_and_create!(current_cart, @user)
        flash[:notice] = 'You have successfully subscribed for qliqCharge.'
        format.html { redirect_to billing_information_subscribe_index_path }
        format.xml { render :xml => @user, :status => :created, :location => @user }
        format.js {
          set_entity
          @billing_info = ProspectiveSubscriberBillingAddress.new
        }
      else
        @user.build_physician_group(params[:prospective_subscriber][:physician_group_attributes])

        format.html { render :action => "new" }
        format.xml { render :xml => @user.errors, :status => :unprocessable_entity }
        format.js {

        }
      end
    end
  end

  # GET /subscribe/1/edit
  # GET /subscribe/1/edit.xml
  def edit
    respond_to do |format|
      format.html
      format.xml { render :xml => @user }
      format.json { render :json => @user.validations_to_json(:name) }
    end
  end

  # PUT /subscribe/1
  # PUT /subscribe/1.xml
  def update
    respond_to do |format|
      @user.attributes = params[:user]
      if @user.save
        LineItem.clear_and_create!(current_cart, @user)

        flash[:notice] = 'You have successfully updated qliqAccount.'
        if @physician_group.billing_info
          format.html { redirect_to subscribe_path(@physician_group) }
        else
          format.html { redirect_to billing_information_subscribe_index_path }
        end
        format.xml { render :xml => @user, :status => :created, :location => @user }
        format.js
      else
        raise @user.errors.inspect
        format.html { render :action => "edit" }
        format.xml { render :xml => @user.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end

  def show
    @billing_info = @physician_group.billing_info
    @order = @physician_group.prepare_order_object
#    unless cookies[:credit_card].nil?
#      @order = @physician_group.prepare_order_object(cookies[:credit_card])
#
#    else
#      redirect_to edit_billing_information_subscribe_index_path, :notice => 'No Credit Card information!'
#    end
    respond_to do |format|
      format.html
      format.xml { render :xml => @physician_group }
      format.json { render :json => @physician_group.validations_to_json(:name) }
    end
  end

  def billing_information
    @billing_info = ProspectiveSubscriberBillingAddress.new

    respond_to do |format|
      format.html
      format.xml { render :xml => @billing_info }
      format.json { render :json => @billing_info.validations_to_json(:name) }
      format.js
    end
  end

  def create_billing_info
    @billing_info = ProspectiveSubscriberBillingAddress.new(params[:prospective_subscriber_billing_address])
    @billing_info.prospective_subscriber = @user
    respond_to do |format|
      if @billing_info.save
        @user.update_attribute(:passed_step, 2)
        #cookies[:credit_card] = @billing_info.credit_card_hash
        flash[:notice] = 'Billing information successfully created.'
        format.html { redirect_to subscribe_path(@physician_group) }
        format.xml { render :xml => @billing_info, :status => :created, :location => @billing_info }
        format.js {
          @billing_info = @physician_group.billing_info
          @order = @physician_group.prepare_order_object
        }
      else
        format.html { render :action => "billing_information" }
        format.xml { render :xml => @billing_info.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end

  def edit_billing_information
    @billing_info = @physician_group.billing_info
    respond_to do |format|
      format.html
      format.xml { render :xml => @billing_info }
      format.json { render :json => @billing_info.validations_to_json(:name) }
    end
  end

  def update_billing_info
    @billing_info = @physician_group.billing_info
    @billing_info.attributes = @user.respond_to?(:resource) ? params[:billing_info] : params[:prospective_subscriber_billing_address]

    #cookies[:credit_card] = @billing_info.credit_card_hash
    respond_to do |format|
      if @billing_info.save
        flash[:notice] = 'Billing information successfully updated.'
        format.html { redirect_to subscribe_path(@physician_group) }
        format.xml { render :xml => @billing_info, :status => :created, :location => @billing_info }
        format.js
      else
        format.html { render :action => "billing_information" }
        format.xml { render :xml => @billing_info.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end

  def providers
  end

  def checkout_confirmation
    render :text => params.inspect
  end

  private
  def set_entity
    begin
      if session[:prospective_subscriber_id]
        @user = ProspectiveSubscriber.find(session[:prospective_subscriber_id])
        @physician_group = @user.physician_group
      else
        @user = current_user || User.find(session[:user_id])
        @physician_group = @user.resource
      end
    rescue
      redirect_to new_subscribe_path
      return
    end
  end
end
