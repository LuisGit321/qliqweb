#if NoteType.table_exists?
  #note_types = NoteType.all
  ADMIT_NOTE = 1 #note_types.select{|a| a.description == "Admit Notes"}.first.id 
  PROGRESS_NOTE = 2 #note_types.select{|a| a.description == "Progress Notes"}.first.id 
  HOSPITAL_COURSE = 3 #note_types.select{|a| a.description == "Hospital Course"}.first.id
  MEDICATION = 4 #note_types.select{|a| a.description == "Medications"}.first.id
  FOLLOWUP_INSTRUCTION = 5 #note_types.select{|a| a.description == "Followup Instructions"}.first.id
  DISCHARGED_NOTES = [HOSPITAL_COURSE, MEDICATION, FOLLOWUP_INSTRUCTION]
#end
