class AgencyEmployee < ActiveRecord::Base
  set_table_name 'agency_employee'
  belongs_to :billing_agency, :class_name => 'BillingAgency', :foreign_key => :billing_agency_id
  has_many :billing_batches, :class_name => 'BillingBatch'
  has_one :user, :as => :resource, :dependent => :destroy
  has_many :billing_superbills, :through => :billing_agency, :source => :superbills

  accepts_nested_attributes_for :user, :allow_destroy => true
  validates :name, :presence => true
end
