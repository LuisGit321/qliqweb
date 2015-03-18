class BillingBatch < ActiveRecord::Base
  set_table_name 'billing_batch'
  belongs_to :agency_employee, :class_name => 'AgencyEmployee', :foreign_key => :agencyemployee_id
  belongs_to :encounter, :class_name => 'Encounter', :foreign_key => :encounter_id
  belongs_to :physician_group, :class_name => 'PhysicianGroup', :foreign_key => :group_id
  belongs_to :physician, :class_name => 'Physician', :foreign_key => :physician_id
end
