class Note < ActiveRecord::Base
  set_table_name 'note'
  has_many :encounters, :through => :encounter_notes, :source => :encounter
  belongs_to :note_type, :class_name => 'NoteType', :foreign_key => :type_id
  has_many :encounter_notes, :class_name => 'EncounterNote', :dependent => :destroy

  validates :text_note, :presence => true
  validates :type_id, :presence => true

  scope :admit_note, :conditions => {:type_id => ADMIT_NOTE}
  scope :progress_notes, :conditions => {:type_id => PROGRESS_NOTE}
  scope :hospital_course, :conditions => {:type_id => HOSPITAL_COURSE}
  scope :medication, :conditions => {:type_id => MEDICATION}
  scope :followup_instruction, :conditions => {:type_id => FOLLOWUP_INSTRUCTION}
  
  scope :get_notes, lambda {|patient_id|
    { :joins => [:encounter_notes => :encounter], :conditions => ["encounter.patient_id = ? ", patient_id],
      :order => "updated_at DESC"   }}

  accepts_nested_attributes_for :encounter_notes, :allow_destroy => true
end
