class Specialty < ActiveRecord::Base
  set_table_name 'specialty'
  has_many :superbills, :class_name => 'Superbill'
end
