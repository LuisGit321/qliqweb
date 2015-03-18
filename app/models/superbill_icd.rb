class SuperbillIcd < ActiveRecord::Base
  set_table_name 'superbill_icd'
  belongs_to :superbill
  belongs_to :icd
  belongs_to :superbill_cpt

  #validates :icd_id, :uniqueness => {:scope => :superbill_id}
end
