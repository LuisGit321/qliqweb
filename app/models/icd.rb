class Icd < ActiveRecord::Base
  set_table_name 'icd'
  has_many :encounter_icds, :class_name => 'EncounterIcd'
  has_many :favorite_icds, :class_name => 'FavoriteIcd'
  has_many :superbill_icds, :class_name => 'SuperbillIcd'
end
