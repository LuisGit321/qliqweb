class PhysicianPref < ActiveRecord::Base
  set_table_name 'physician_pref'
  belongs_to :facility, :class_name => 'Facility', :foreign_key => :defacto_facility_id
  belongs_to :physician, :class_name => 'Physician', :foreign_key => :physician_id
  validates_numericality_of :number_of_days_to_bill, :greater_than_or_equal_to => 0, :allow_nil => true, :message => 'Please enter valid number'
end
