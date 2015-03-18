class State < ActiveRecord::Base
  set_table_name 'state'
  has_many :superbills, :class_name => 'Superbill'
end
