class BillingAgency < ActiveRecord::Base
  set_table_name 'billing_agency'
  has_many :agency_employees, :class_name => 'AgencyEmployee', :dependent => :destroy
  has_many :billing_prefs, :class_name => 'BillingPref'
  has_many :physician_groups, :through => :billing_prefs
  has_many :superbills, :class_name => 'Superbill', :dependent => :destroy
  has_many :agency_users, :through => :agency_employees, :source => :user

  has_one :user, :as => :resource, :dependent => :destroy
  accepts_nested_attributes_for :user, :allow_destroy => true 
  accepts_nested_attributes_for :billing_prefs, :allow_destroy => true 
 
  validates :first_name, :presence => true#, :uniqueness => true
  validates :last_name , :presence => true#, :uniqueness => true
 # validates :phone, :presence => true, :format => { :with =>  /^(\d{3}-){2}\d{4}$/, :message => 'Invalid phone number'}
 # validates_numericality_of :zip, :greater_than_or_equal_to => 0 , :less_than_or_equal_to => 999999,  :allow_blank => true, :only_integer => true, :message => 'Invalid value for zip'
 # validate :validate_zip
  def validate_zip
    unless self.zip.empty?
      validates_length_of :zip, :minimum => 5, :maximum => 10
    end
  end

 # validates_format_of :fax, :with =>  /^(\d{3}-){2}\d{4}$/, :allow_blank => true, :message => 'Invalid fax number'
  #
end
