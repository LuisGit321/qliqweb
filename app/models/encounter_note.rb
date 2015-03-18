class EncounterNote < ActiveRecord::Base
  set_table_name 'encounter_note'
  belongs_to :encounter, :class_name => 'Encounter', :foreign_key => :encounter_id
  belongs_to :note, :class_name => 'Note', :foreign_key => :note_id, :dependent => :destroy
end
