class NoteType < ActiveRecord::Base
  set_table_name 'note_type'
  has_many :notes, :class_name => 'Note'
end
