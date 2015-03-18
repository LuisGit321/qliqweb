class Superbill < ActiveRecord::Base
  set_table_name 'superbill'
  has_one :physician_superbill
  belongs_to :state, :class_name => 'State', :foreign_key => :state_id
  belongs_to :specialty, :class_name => 'Specialty', :foreign_key => :specialty_id
  belongs_to :billing_agency, :class_name => 'BillingAgency', :foreign_key => :billing_agency_id
  has_many :superbill_cpts, :class_name => 'SuperbillCpt', :dependent => :destroy
  has_many :superbill_icds, :through => :superbill_cpts
  has_many :uniq_superbill_cpts, :class_name => 'SuperbillCpt', :group => "cpt_group_id"
  has_many :superbill_modifiers
  has_many :modifiers , :through => :superbill_modifiers

  accepts_nested_attributes_for :superbill_cpts, :allow_destroy => true

  validates :name, :presence => true, :uniqueness => true
  #validates :state_id, :presence => true
  validates :specialty_id, :presence => true

  def hash_response
    {
        "name" => name,
        "facility_type" => physician_superbill.facility_type ? physician_superbill.facility_type.name : '',
        "preferred" => physician_superbill.preferred.to_s,
        "superbill_cpts" => superbill_cpts.collect { |cpt| cpt.for_supperbill_hash },
        "superbill_modifiers" => modifiers.collect { |mdfr| {:modifier => mdfr.name || ''}}

    }
  end
end
