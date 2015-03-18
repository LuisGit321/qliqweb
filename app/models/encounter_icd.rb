class EncounterIcd < ActiveRecord::Base
  set_table_name 'encounter_icd'
  belongs_to :icd, :class_name => 'Icd', :foreign_key => :icd_id
  belongs_to :encounter, :class_name => 'Encounter', :foreign_key => :encounter_id

  scope :primary, :conditions => {:primary_diagnosis => 1}
  scope :general, :conditions => {:primary_diagnosis => 0}

  validates :icd_id, :uniqueness => {:scope => :encounter_id} 
end
