class Physician < ActiveRecord::Base
  set_table_name 'physician'
  has_many :app_registrations, :class_name => 'AppRegistration'
  has_many :app_yet_tobe_registereds, :class_name => 'AppYetTobeRegistered'
  has_many :billing_batches, :class_name => 'BillingBatch'
  has_many :custom_procedures, :class_name => 'CustomProcedure'
  has_many :encounters, :class_name => 'Encounter'
  has_many :favorite_facilities, :class_name => 'FavoriteFacility'
  has_many :favorite_icds, :class_name => 'FavoriteIcd'
  has_many :patients, :class_name => 'Patient'
  belongs_to :physician_group, :class_name => 'PhysicianGroup', :foreign_key => :group_id
  has_one :physician_pref, :class_name => 'PhysicianPref'
  has_many :physician_superbills, :class_name => 'PhysicianSuperbill'
  has_one :billing_agency, :through => :billing_pref
  has_many :referring_physicians, :as => :resource, :dependent => :destroy
  has_many :facilities, :as => :resource, :dependent => :destroy
  has_many :superbills, :through => :physician_superbills
  has_one :user, :as => :resource, :dependent => :destroy
  has_many :favorite_icd_codes, :through => :favorite_icds, :source => :icd
  belongs_to :print, :dependent => :destroy


  accepts_nested_attributes_for :user, :allow_destroy => true, :reject_if => proc { |attributes| attributes['roles'].blank? }
  #accepts_nested_attributes_for :billing_pref, :allow_destroy => true #, :reject_if => proc { |attributes| attributes['billing_agency_id'].blank? }

  accepts_nested_attributes_for :physician_pref, :allow_destroy => true

  scope :by_billing_agency, lambda { |billing_agency_id| joins(:billing_pref).where("billing_agency_id = ?", billing_agency_id) }
  scope :physicians_billing_agency, lambda { |billing_agency_id, physician_ids| joins(:billing_pref).where("billing_agency_id = ? and physician.id in (?)", billing_agency_id, physician_ids) }
  scope :by_npi_and_email, lambda { |npi, email| joins(:user).where("npi = ? and users.email = ?", npi, email).readonly(false) }

  validates :first_name, :last_name, :presence => true

  # - Instance Methods -
  def fullname
    "#{ first_name } #{ last_name }"
  end


end
