class HomeController < ApplicationController
  layout 'home'
  caches_page :index

  def index
    @registration = Registration.new
    session[:user_id] = 12
  end

  def unsubscribe
    @registration = Registration.find_by_email(params['email'])
    @registration.destroy unless @registration.nil?
    @registration = Registration.new if @registration.nil?
    flash[:notice] = "Successfully unsubscribed."
    render :action => 'index'
  end

  def create
    @registration = Registration.new(params[:registration])
    respond_to do |format|
      if @registration.save
        format.js {
          flash[:notice] = "Thank you for contacting us. We will get back to you in a short while."
          render :js => "window.location='#{root_path}'"
        }
      else
        @error = "Please enter valid information."
        format.js {
          render :partial => 'create'
        }
      end
    end
  end

  def client_authentication
    respond_to do |format|
      format.json {
        begin
          parsed_json = JSON.parse(ActiveSupport::JSON.encode(params))

          user_name = parsed_json['Message']['Data']['user_name']
          password = parsed_json['Message']['Data']['password']
          public_key = parsed_json['Message']['Data']['public_key']


          user = User.find(:first, :conditions => ['email = ? and lower(encrypted_password) = ?', user_name, password.downcase])
          response = {}
          if user.nil?
            response = {"Error" => "Invalid credential"}
          else
            set_public_key(public_key, user) if public_key
            response = get_buddy_list(user)
          end
        rescue Exception => err
          response = {"Error" => err.message}
          puts err.message
          puts err.backtrace
        end
        render :json => response.to_json
      }
    end
  end

  def get_buddy_list(user)
    hash = {"Message" => {
        "Type" => "web2client",
        "Command" => "authorization",
        "Subject" => "buddylist",
        "Data" =>{
            "SipServerInfo" => {
                "sip_server_url" => SIP_DOMAIN,
                "sip_server_port" => SipServerPort,
                "sip_server_transport" => SipServerTransport
            },
            "WebServerInfo" => {
                "web_app_url" => "http://www.qliqsoft.com",
                "web_auth_url" => "http://www.qliqsoft.com/auth"
            },
            "UserInfo" => user.group_member_hash.merge(
                "user_id" => user.email,
                "user_sip_uri" => user.sip_uri,
                "user_display_name" => user.name,
                "username" => user.email
            ),
            "GroupInfo" => {
                "group" => {},
                "members" => []
            },
            "BuddyList" => []
        }
    }
    }

    physician_group = user.resource.class.name == "PhysicianGroup" ? user.resource : user.resource.physician_group
    hash["Message"]["Data"]["GroupInfo"]["group"] = {
        "name" => physician_group.name,
        "address" => physician_group.address,
        "city" => physician_group.city,
        "state" => physician_group.state,
        "zip" => physician_group.zip
    }
    buddy_list_users = []
    buddy_list_users << physician_group.user unless user == physician_group.user

    physician_group.physicians.each do |physician|
      buddy_list_users << physician.user unless physician.user == user
    end
    billing_prefs = physician_group.billing_prefs
    unless billing_prefs.blank?
      billing_prefs.each do |pref|
        ba_user = pref.billing_agency.user
        buddy_list_users << ba_user unless ba_user == user
      end
    end
    buddy_list_users.each do |bl_user|
      hash["Message"]["Data"]["BuddyList"] << bl_user.buddy_list_item_hash
      hash["Message"]["Data"]["GroupInfo"]["members"] << bl_user.group_member_hash
    end

    return hash
  end

  def forgot_password
    respond_to do |format|
      format.json {
        begin
          physician = Physician.by_npi_and_email(params[:npi], params[:user_name]).first
          user = physician.user unless physician.blank?
          response = {}
          if user.nil?
            response = {"Error" => "Invalid credential"}
          else
            response = get_password
            user.send_reset_password_instructions
          end
        rescue Exception => err
          response = {"Error" => err.message}
        end
        render :json => response.to_json
      }
    end
  end

  def set_pin
    respond_to do |format|
      format.json {
        begin
          physician = Physician.by_npi_and_email(params[:npi], params[:user_name]).first
          user = physician.user unless physician.blank?
          response = {}
          if user.nil?
            response = {"Error" => "Invalid credential"}
          else
            user.pin = params[:pin]
            user.md5pin = params[:md5pin]
            user.save(false)
            response = {"Message" => {"Type" => "web2client", "Command" => "authorization", "Subject" => "store_pin_reply", "Data" => {"success" => "pin stored successfully."}}}
          end
        rescue Exception => err
          response = {"Error" => err.message}
        end
        render :json => response.to_json
      }
    end
  end

  def forgot_pin
    respond_to do |format|
      format.json {
        begin
          physician = Physician.by_npi_and_email(params[:npi], params[:user_name]).first
          user = physician.user unless physician.blank?
          response = {}
          if user.nil?
            response = {"Error" => "Invalid credential"}
          else
            response = {"Message" => {"Type" => "web2client", "Command" => "authorization", "Subject" => "store_pin_reply", "Data" => {"user_name" => "amit@joshsoftware.com", "pin" => user.pin}}}
          end
        rescue Exception => err
          response = {"Error" => err.message}
        end
        render :json => response.to_json
      }
    end
  end

  def get_password
    hash = {"Message" => {"Type" => "web2client", "Command" => "authorization", "Subject" => "forgot_pw_reply", "Data" => {"success" => "A temporary password is sent. please check your email and complete process."}}}
    return hash
  end

  def set_public_key(key, user)
    sip_config = user.user_sip_config
    if sip_config and (sip_config.public_key.blank? or sip_config.public_key != key)
      sip_config.public_key = key
#      resource = user.resource != "Physician" ? user.resource : user.resource.billing_agency
#      if user.resource == "Physician"
#        group_name = user.resource.physician_group.name
#      else
#        group_name = ""
#         billing_pref = BillingPref.where(:billing_agency_id => user.resource.id)
#         unless billing_pref.blank?
#           billing_pref = billing_pref.first
#           group_name = billing_pref.physician_group.name
#         end
#      end
      sip_config.sip_uri = user.sip_uri #"sip://#{resource.first_name}.#{resource.last_name}.#{group_name}@129.92.43.37"
      sip_config.save
    end
  end
end
