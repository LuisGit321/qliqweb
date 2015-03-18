class User < ActiveRecord::Base
  require 'active_support/secure_random'
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable,
         :encryptable, :encryptor => :md5

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :password,  :password_salt, :password_confirmation, :remember_me, :username, :resource_type, :resource_id, :roles
  #attr_accessor :email, :password,  :password_salt, :password_confirmation

  belongs_to :resource, :polymorphic => true, :dependent => :destroy
  has_many :prints, :dependent => :destroy
  has_many :videos, :dependent => :destroy
  has_one :user_sip_config, :dependent => :destroy
  #after_create :set_user_sip_config
  validates :roles, :presence => true

  scope :with_role, lambda { |role| {:conditions => "roles_mask & #{2**ROLES.index(role.to_s)} > 0"} }

  validates :email, :presence => true, :uniqueness => true, :format =>{ :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }

  validates :password, :presence => true,
            :confirmation => true,
            :length => {:within => 6..40},
            :on => :create
  validates :password, :confirmation => true,
            :length => {:within => 6..40},
            :allow_blank => true,
            :on => :update

  accepts_nested_attributes_for :resource
  #attr_accessible :sip_uri

  def confirmation_required?
    false
#    if self.resource_type == "PhysicianGroup" && self.sign_in_count <= 1
#      return false
#    else
#      super
#    end
  end

  def build_resource(params = {})
    self.resource = PhysicianGroup.new(params)
  end

  def reset_email
    self.confirmed_at = nil
    self.save!
    self.send_confirmation_instructions
  end


  before_validation(:on => :create) do
    self.password = ActiveSupport::SecureRandom.base64(6) if self.resource_type != "PhysicianGroup"
  end

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end

  def roles
    ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
  end

  def role?(role)
    roles.include? role.to_s
  end

  def set_user_sip_config
    UserSipConfig.create!(:user_id => self.id)

  end

  def get_buddies_email
    physician_group = self.resource.class.name == "PhysicianGroup" ? self.resource : self.resource.physician_group
    buddies = physician_group.physicians.collect { |p| p.user.email }

    buddies = [] if buddies.nil?
    billing_prefs = physician_group.billing_prefs
    unless billing_prefs.blank?
      billing_prefs.each do |pref|
        user = pref.billing_agency.user
        buddies << user.email
      end
    end
    buddies
  end

  def get_buddies_sip_uri
    physician_group = self.resource.class.name == "PhysicianGroup" ? self.resource : self.resource.physician_group
    buddies = physician_group.physicians.collect { |p| p.user.sip_uri }
    buddies += physician_group.billing_agencies.collect { |p| p.user.sip_uri }

#    buddies = [] if buddies.nil?
#    billing_prefs = physician_group.billing_prefs
#    unless billing_prefs.blank?
#      billing_prefs.each do |pref|
#        user = pref.billing_agency.user
#        buddies << "sip:#{p.user.username}@#{DOMAIN}"
#      end
#    end
    buddies
  end

  def sip_uri
    "#{custom_username}@#{SIP_DOMAIN}"
  end

  def custom_username
     "#{resource.first_name}_#{resource.last_name}".downcase if resource
  end

  def custom_username_bad
    if resource.group_name.length == 0
       "#{resource.first_name}_#{resource.last_name}".downcase if resource
    else
       "#{resource.first_name}_#{resource.last_name}_#{resource.group_name}".downcase if resource
    end
  end

  def group_name
    if resource_type == 'Physician'
      resource.physician_group.name
    elsif resource_type == 'BillingAgency'
      resource.physician_groups.first.name if resource.physician_groups.first
    elsif resource_type == 'PhysicianGroup'
      resource.name
    end
  end

  def set_password_and_salt(pass, salt)
    self.encrypted_password = pass
    self.password_salt = salt
    save!
  end

  def name
    "#{resource.first_name} #{resource.last_name}"
  end

  def initials
    "#{resource.first_name[0].chr}#{resource.last_name[0].chr}".upcase
  end

  def buddy_list_item_hash
    {
        "display_name" => name,
        "user_id" => email,
        "sip_uri" => sip_uri || "",
        "public_key" => user_sip_config ? user_sip_config.public_key || "" : ""
    }
  end

  def group_member_hash
    {"role" => roles,
     "name" => name,
     "initials" => initials,
     "specialty" => "",
     "state" => resource.state || "",
     "zip" => resource.zip || "",
     "npi" => "",
     "mobile" => resource.respond_to?(:mobile) ? resource.mobile || "" : "",
     "mobile" => resource.respond_to?(:phone) ? resource.phone || "" : "",
     "mobile" => resource.respond_to?(:fax) ? resource.fax || "" : "",
     "email" => email
    }

  end

  class << self
    #with json request
    def store_pin(params)
      response = {}
      begin
        parsed_json = JSON.parse(ActiveSupport::JSON.encode(params))

        user_name = parsed_json['Message']['Data']['user_name']
        password = parsed_json['Message']['Data']['encrypted_password']
        p_pin = parsed_json['Message']['Data']['pin']

        user = self.where(['email = ? and lower(encrypted_password) = ?', user_name, password.downcase]).first
        if user.nil?
          response.merge!("Error" => "Invalid credential")
        else
          user.pin = p_pin
          user.save
          response.merge!('Message' => {
              'Type' => parsed_json['Message']['Type'],
              'Command' => parsed_json['Message']['Command'],
              'Subject' => parsed_json['Message']['Subject'],
              'Data' => {"success" =>"pin stored successfully."}
          })
        end
      rescue => err
        response.merge!("Error" => err)
      end
      response
    end

    def forgot_pin(params)
      response = {}
      begin
        parsed_json = JSON.parse(ActiveSupport::JSON.encode(params))

        user_name = parsed_json['Message']['Data']['user_name']
        password = parsed_json['Message']['Data']['encrypted_password']

        user = self.where(['email = ? and lower(encrypted_password) = ?', user_name, password.downcase]).first
        if user.nil?
          response.merge!("Error" => "Invalid credential")
        else
          response.merge!('Message' => {
              'Type' => parsed_json['Message']['Type'],
              'Command' => parsed_json['Message']['Command'],
              'Subject' => parsed_json['Message']['Subject'],
              'Data' => {"user_name" => user_name,
                         "pin" => user.pin
              }
          })
        end
      rescue => err
        response.merge!("Error" => err)
      end
      response
    end

    def forgot_password_service(params)
      response = {}
      begin
        parsed_json = JSON.parse(ActiveSupport::JSON.encode(params))

        user_name = parsed_json['Message']['Data']['user_name']

        user = self.where(:email => user_name).first
        if user.nil?
          response.merge!("Error" => "Invalid parameters")
        else

          user.reset_password_token= User.reset_password_token
          user.save
          Notifier.password_reset_notification(user).deliver
          response.merge!('Message' => {
              'Type' => parsed_json['Message']['Type'],
              'Command' => parsed_json['Message']['Command'],
              'Subject' => parsed_json['Message']['Subject'],
              'Data' => {
                  "success" => "A password reset link is sent. Please check your email and complete process."
              }
          })
        end
      rescue => err
        response.merge!("Error" => err)
      end
      response
    end

    def superbill_pull(params)
      response = {}
      begin
        parsed_json = JSON.parse(ActiveSupport::JSON.encode(params))

        user_name = parsed_json['Message']['Data']['user_name']
        password = parsed_json['Message']['Data']['encrypted_password']

        user = self.where(['email = ? and lower(encrypted_password) = ?', user_name, password.downcase]).first
        if user.nil? || user.resource_type != 'Physician'
          response.merge!("Error" => "Invalid credential")
        else
          response.merge!('Message' => {
              'Type' => parsed_json['Message']['Type'],
              'Command' => parsed_json['Message']['Command'],
              'Subject' => parsed_json['Message']['Subject'],
              'Data' => {
                  "UserInfo" => {
                      "user_name" => user_name
                  },
                  "Superbills" => user.resource.superbills.collect { |sb| {:Superbill => sb.hash_response} },
                  "master_cpt_pft" => MasterCptPft.all.collect { |obj| {:cpt_code => obj.cpt_code, :pft => obj.pft || ''} },
                  "master_icd_pft" => MasterIcdPft.all.collect { |obj| {:icd_code => obj.icd_code, :pft => obj.pft || ''} }

              }
          })
        end
      rescue => err
        response.merge!("Error" => err)
      end
      response
    end

  end
end
