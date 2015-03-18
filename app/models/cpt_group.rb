class CptGroup < ActiveRecord::Base
  set_table_name 'cpt_group'
  has_many :superbill_cpts, :class_name => 'SuperbillCpt'
end
