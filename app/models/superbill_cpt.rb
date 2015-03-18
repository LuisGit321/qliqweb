class SuperbillCpt < ActiveRecord::Base
  set_table_name 'superbill_cpt'
  belongs_to :superbill
  belongs_to :cpt_group
  belongs_to :cpt
  has_many :encounter_cpts
  has_many :superbill_icds, :dependent => :destroy
  has_many :superbill_cpt_modifiers

  accepts_nested_attributes_for :superbill_icds, :allow_destroy => true

  def for_supperbill_hash
    {
        "cpt_group" => cpt_group.name || '',
        "group_display_order" => cpt_display_oder || '',
        "cpt_code" => cpt.code || '',
        "code_display_order" => group_display_order || '',
        "superbill_icd" => superbill_icds.collect { |sicd| {:icd_code => sicd.icd.code || ''} }

    }
  end
end
