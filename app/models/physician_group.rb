class PhysicianGroup < ActiveRecord::Base
  set_table_name 'physician_group'

  # - Relationships -
  has_many :billing_batches, :class_name => 'BillingBatch', :foreign_key => :group_id
  has_many :billing_prefs, :dependent => :destroy
  has_many :billing_agencies, :through => :billing_prefs, :source => :billing_agency
  has_many :physicians, :class_name => 'Physician', :foreign_key => :group_id
  has_many :referral_physicians, :through => :physicians, :source => :referring_physicians
  has_many :group_facilities, :through => :physicians, :source => :facilities
  has_one :billing_info, :as => :resource, :dependent => :destroy
  has_one :billing_pref
  has_one :billing_agency, :through => :billing_pref
  has_one :user, :as => :resource, :dependent => :destroy
  has_one :line_item, :as=> 'purchasable'
  belongs_to :print, :dependent => :destroy

  accepts_nested_attributes_for :billing_prefs, :allow_destroy => true
  accepts_nested_attributes_for :billing_agencies, :allow_destroy => true, :reject_if => :check_billing_attributes
  accepts_nested_attributes_for :physicians, :allow_destroy => true

  # - Validations -
  validates_numericality_of :providers, :only_integer => true,
                            :greater_than_or_equal_to => 1
  validates_presence_of :name, :address, :city, :state,
                        :admin_email, :admin_password
  validates :zip, :presence => true, :format => {:with => /^\d{5}(-?\d{4})?$/, :message => 'Invalid zip code'}
  validates :phone, :presence => true, :format => {:with => /^(\d{3}-?){2}\d{4}$/, :message => 'Invalid phone number'}
  validates :fax, :format => {:with => /^(\d{3}-?){2}\d{4}$/, :allow_blank => true, :message => 'Invalid fax number'}


  # - Instance Methods -
  def check_billing_attributes(attributes)
    return true if attributes["first_name"].blank? && attributes["last_name"].blank? && attributes["user_attributes"]["email"].blank?
    return false
  end

  scope :by_billing_agency, lambda { |billing_agency_id| joins(:billing_prefs).where("billing_agency_id = ?", billing_agency_id) }

  def listing_charge
    #per provider
    50
  end

  def purchased
    self.update_attribute(:paid, true)
  end

  def prepare_order_object
    Order.new(
        :first_name => first_name,
        :last_name => last_name,
        :country => 'US',
        :state => state,
        :city => city,
        :zip_code => zip,
        :phone => phone,
        :email => admin_email
    )
  end
end
