class EncounterCpt < ActiveRecord::Base
  set_table_name 'encounter_cpt'
  belongs_to :superbill_cpt, :class_name => 'SuperbillCpt', :foreign_key => :superbill_cpt_id
  belongs_to :encounter, :class_name => 'Encounter', :foreign_key => :encounter_id
  validates :superbill_cpt_id , :uniqueness => {:scope => :encounter_id}
end
