class PhysicianSuperbill < ActiveRecord::Base
  set_table_name 'physician_superbill'
  belongs_to :physician, :class_name => 'Physician', :foreign_key => :physician_id
  belongs_to :superbill, :class_name => 'Superbill', :foreign_key => :superbill_id
  belongs_to :facility_type

  scope :preferred, :conditions => { :preferred =>  1}
end

