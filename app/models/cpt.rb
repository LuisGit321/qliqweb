class Cpt < ActiveRecord::Base
  set_table_name 'cpt'
  has_many :superbill_cpts, :class_name => 'SuperbillCpt'
end
